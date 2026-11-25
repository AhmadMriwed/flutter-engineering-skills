# Applying the stack to other feature shapes

| Scenario | Files and input | Behavior and checks |
| --- | --- | --- |
| Static help | Route, page, translation keys and optional HelpSection widget | Use AppScaffold or the target shared scaffold. Verify reflow and scroll. No controller is required for static copy. |
| Remote articles | Remote adapter, article model, API-backed repository, locator, binding and list page | Use the [Tasks list](TASKS_FEATURE.md) code, remove filters and paging when the API returns a fixed list, and keep initial loading, empty and retry. |
| CRUD notes | [Tasks templates](../templates/TEMPLATES.md) and a confirmed delete endpoint if the product supports removal | Add delete to gateway, source, repository and detail controller. Confirm intent, disable duplicate actions, return true after success, and retain the record if delete fails. |
| Authenticated profile | Route/binding, form controller, auth repository, AppStorage and session service | Submit only after validation. Persist session on success, use gateway auth policy on protected endpoints, and clear account state once on sign-out or expiry. |
| Complex detail | Page with slivers, feature header/media/details sections, independently owned media controller when interactive | Use one scroll owner and lazy construction. Release playback on route inactivity. Open external deep links only after target validation. |
| Multiple independent reads | One feature controller or scoped secondary controller for options, repositories owned by their capabilities | Load each independent section with its own state, retry scoped errors and preserve successful content. Sequence dependent requests explicitly. |

The source evidence for these shapes is delivery schedule, FAQ, address forms, auth session, product details and search filter options. Full copyable source for list, detail, create and update is in [Tasks feature](TASKS_FEATURE.md).
