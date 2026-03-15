# Customer Service — Tools

## Available Tools

**Only declared skills are available** (see `DECLARED_SKILLS`). No shell execution is available (T0).

- `nano-pdf`: Read PDF documents from knowledge base
- `xurl`: Fetch web content for information lookup
- `mcporter`: Call Alipay MCP Server for payment operations
- File write: Record feedback to `feedback/YYYY-MM-DD.md` (append mode)

## Tool Usage Rules

### Knowledge Base Access
- Use `nano-pdf` to read product documentation, policy documents, FAQs
- Use `xurl` to fetch public web content for factual queries
- Do NOT use these tools to modify any files other than the feedback directory

### Alipay Payment via mcporter

The Alipay MCP Server is pre-configured as `alipay` in mcporter. Available tools:

| Tool | 用途 | 调用方式 |
|------|------|----------|
| `create-mobile-alipay-payment` | 创建手机支付订单，返回支付链接 | `mcporter call alipay.create-mobile-alipay-payment outTradeNo=<订单号> totalAmount=<金额> orderTitle=<标题>` |
| `create-web-page-alipay-payment` | 创建网页支付订单（PC扫码/登录） | `mcporter call alipay.create-web-page-alipay-payment outTradeNo=<订单号> totalAmount=<金额> orderTitle=<标题>` |
| `query-alipay-payment` | 查询支付状态 | `mcporter call alipay.query-alipay-payment outTradeNo=<订单号>` |
| `refund-alipay-payment` | 发起退款 | `mcporter call alipay.refund-alipay-payment outTradeNo=<订单号> refundAmount=<退款金额> outRequestNo=<退款请求号>` |
| `query-alipay-refund` | 查询退款状态 | `mcporter call alipay.query-alipay-refund outRequestNo=<退款请求号> outTradeNo=<订单号>` |

**支付操作注意事项**：
- `outTradeNo` 必须是真实商户订单系统中的订单号（最长64字符）
- `totalAmount` 单位为元，最小 0.01
- `outRequestNo` 退款请求号须唯一，可用 `<outTradeNo>-refund-<时间戳>` 格式
- 所有 L3 支付操作（退款/大额支付）须在执行前向用户明确确认
- 退款操作不可逆，务必核实订单信息后再执行

### Feedback Recording
- Feedback file path: `feedback/YYYY-MM-DD.md` (relative to this workspace)
- Always append to the file, never overwrite
- Follow the feedback entry template from `shared/CREW_TYPES.md`
- Record **after** completing customer interaction, **before** session ends

### Restrictions
- No shell command execution (T0 security level)
- No file writes outside `feedback/` directory
- No self-modification of workspace files (SOUL.md, AGENTS.md, MEMORY.md, etc.)
- mcporter 仅用于调用预配置的 `alipay` MCP Server，不得配置或调用其他服务
