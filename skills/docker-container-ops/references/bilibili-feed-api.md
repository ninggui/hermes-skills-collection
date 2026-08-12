# B站 API 412风控绕过：Feed聚合接口

## 问题
容器内通过 `bilibili-api` SDK 逐个获取UP主视频时，服务器IP被B站标记为数据中心IP，所有 `get_videos()` 调用返回412错误码（触发安全风控策略）。

## 根因
B站对非住宅IP段（云服务器/IDC）有严格的API访问限制，即使使用有效Cookie，批量请求也会被拦截。与频率无关，首个请求即被拦。

## 解决方案：关注动态Feed API

用 B站 关注动态聚合接口替代逐个UP主查询：

```
https://api.bilibili.com/x/polymer/web-dynamic/v1/feed/all?type=video&page=N
```

### 优势
- 1次请求获取20条视频（所有关注UP主的最新动态聚合）
- 替代原本620次逐个UP主查询（98%减少）
- 不触发412风控（实测通过）
- 翻页使用offset游标

### 限制
- 不返回 `pubdate`（发布时间），需额外调 `/x/web-interface/view?bvid=xxx` 确认
- 每页20条，翻页间隔建议2秒

## 实现要点

```python
import requests

COOKIE_STR = "SESSDATA=xxx; bili_jct=xxx; buvid3=xxx"
HEADERS = {
    "User-Agent": "Mozilla/5.0 ...",
    "Cookie": COOKIE_STR,  # 原始字符串，不做%2C二次编码
    "Referer": "https://www.bilibili.com/"
}

# 翻页直到遇到24小时前的视频
page = 1
while True:
    resp = requests.get(
        f"https://api.bilibili.com/x/polymer/web-dynamic/v1/feed/all",
        params={"type": "video", "page": page},
        headers=HEADERS
    )
    data = resp.json()
    for item in data["data"]["items"]:
        # 提取 bvid/aid/title
        archive = item.get("modules", {}).get("module_dynamic", {}).get("major", {}).get("archive", {})
        bvid = archive.get("bvid")
        aid = archive.get("aid")
        title = archive.get("title")
        # 确认 pubdate：GET /x/web-interface/view?bvid=xxx
        # 24小时外的视频 → 停止翻页
    
    if not data["data"].get("has_more"):
        break
    page += 1
    time.sleep(2)
```

## 关键注意事项
- **Cookie传递**：不能通过 `requests.Session().cookies.set()`（会对%2C二次编解码），必须在header中传递原始Cookie字符串
- **停止条件**：遇到24小时外的视频立即停止翻页（Feed按时间倒序）
- **pubdate缺失**：Feed不返回发布时间，需额外API调用确认
