# Portal attachment links

The four ESS Management actions now accept `documentURLs` as Text containing a JSON array of absolute HTTP/HTTPS URL strings, for example:

```json
"documentURLs": "[\"https://hrms.billenergy.com/documents/view?module=Attachment&type=attachment&id=7c9e6679-7425-40de-944b-e07fc1f90ae7\"]"
```

Send `"documentURLs": "[]"` when there are no attachments. An empty string is also accepted. Existing callers should include the new parameter. Other ESS actions are unchanged.

BC stores URLs as native Record Links with description `Portal attachment`. Open them from the Links FactBox on the transaction card. Purchase Invoice and Posted Purchase Invoice use their standard Links FactBoxes. Physical files are not downloaded or stored. Portal authentication and access checks still apply when opening a link.

URLs are preserved exactly, including encoded query strings. Malformed JSON, null entries, non-HTTP(S) URLs, and URLs exceeding Record Link.URL1 capacity fail the action. Links are appended; duplicate URLs on the same record/company are skipped. Empty arrays do not remove existing links.

## Posting routes

| Source | Destination | Handling |
| --- | --- | --- |
| Payment Request | Payment Voucher | Copy through the existing voucher creation event; later portal retries also update existing vouchers. |
| Cash Advance | Payment Voucher | Copy through the existing voucher creation event; later portal retries also update its linked voucher. |
| Cash Advance | Retirement | Copy through the existing retirement creation event. |
| Payment Voucher | Posted Payment Voucher | Same header record, so links remain. |
| Cash Advance | Posted Cash Advance | Same header record, so links remain. |
| Retirement | Posted Retirement | Same header record, so links remain. |
| Purchase Invoice | Posted Purchase Invoice | Copy during purchase invoice posting; skip posting preview. |

Only portal links are copied by this integration. Existing physical attachment handling continues independently. No sales endpoint is changed.

The current Purchase Invoice action also requires `postingDescription`, which is absent from the supplied portal example. Include that existing parameter (an empty string is accepted).

## Sandbox acceptance checks

1. Call each action with two portal URLs; verify the document has two clickable Links and that each opens the original portal URL.
2. Retry with the same URLs and one additional URL; verify only the additional link is inserted. Retry with `[]`; verify existing links remain.
3. Create and post the payment request/cash advance voucher; verify Links on the posted voucher. Add another URL through the source endpoint after voucher creation and verify it reaches that voucher.
4. Create a retirement from a cash advance, then submit retirement receipt URLs and post it; verify Links on the posted retirement.
5. Create a purchase invoice, update it by document number, preview posting, and post it; verify the update targets the invoice and links exist on the posted invoice. Verify preview leaves no posted links behind.
6. Submit invalid JSON, null/object entries, a non-HTTP(S) URL and an overlength URL; verify the action fails without committing partial changes.

Compilation does not replace these BC/portal runtime checks. Deploy to a sandbox before production.