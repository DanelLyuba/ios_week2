# NovaSteel · Cloud Product Explorer & Detail Carousel

Flutter lab: live REST catalogue (`https://fakestoreapi.com/products`) for the
fictional stainless-steel construction company **NovaSteel**. Prices are shown
in tenge (₸).

## Run it

```bash
# 1. once, inside this folder (creates android/ ios/ web/ around the code)
flutter create . --project-name novasteel_explorer --org kz.novasteel --platforms=android,ios,web
#    (or just run setup.bat on Windows / ./setup.sh on macOS & Linux)

# 2. every time
flutter pub get
flutter run
flutter test        # model, service (200/404/500/timeout/offline) and UI tests
```

> **Release APK only:** add `<uses-permission android:name="android.permission.INTERNET"/>`
> to `android/app/src/main/AndroidManifest.xml`. Debug runs already have it.

## Rubric map (10 pts)

| Pts | Requirement | Where |
|-----|-------------|-------|
| 2.5 | `Product` model, `fromJson`, null-safe + `num` safe | `lib/models/product.dart` |
| 2.5 | Async fetch, 10 s timeout, try/catch, 3 states, Retry, pull-to-refresh | `lib/services/product_service.dart`, `lib/screens/product_list_screen.dart`, `lib/widgets/error_view.dart` |
| 3.0 | Detail screen, `Hero('product_image_${id}')`, `PageView.builder`, dots + `1 / 3` counter, category badge, description, sticky Add to Cart | `lib/screens/product_detail_screen.dart` |
| 2.0 | Share sheet with `narxoz://store/product/{id}` + copy button, live defense | `lib/widgets/share_sheet.dart`, section below |

Lab objectives covered: `http: ^1.2.0`, status codes 200 / 404 / 500,
`(json['price'] as num).toDouble()` safety, `CircularProgressIndicator`,
`ListView.separated` + `RefreshIndicator`, `ElevatedButton` retry, Hero,
`PageView.builder`, animated dots, modal bottom sheet.

## Architecture

```
lib/
  main.dart                      app entry
  core/theme.dart                NovaSteel palette + ThemeData
  core/format.dart               tenge formatting, kUsdToKzt rate
  models/product.dart            Product + safe fromJson
  services/product_service.dart  http.get + timeout + ApiException
  screens/product_list_screen    Loading -> Feed -> Error state machine
  screens/product_detail_screen  Hero, carousel, sticky bar, share
  widgets/                       card, error view, share sheet, badges
test/                            unit + widget tests
```

State is a plain `enum LoadState { loading, success, error }` driven by
`setState`. Retry and pull-to-refresh both reuse the same service call, so
nothing needs a restart.

## Notes worth knowing

* **Prices:** the API returns USD. `formatTenge()` multiplies by `kUsdToKzt`
  (520) in `lib/core/format.dart`. Change that one constant to re-price.
* **Carousel:** the API gives one image per product, so the 3 slides are the
  front view plus two zoomed crops. `Product.gallery` is the single place to
  swap in real multi-image data.
* **Refresh failure:** if pull-to-refresh fails while the feed is on screen, a
  snackbar appears and the existing list stays (the user never loses content).

## Live defense: airplane-mode script (2 pts)

1. Launch the app online: spinner, then the feed.
2. Turn on **Airplane mode**.
3. Pull down to refresh: snackbar "Refresh failed", feed stays.
4. Fully restart the app offline (or hot restart): spinner, then the
   **Connection lost** screen (or after 10 s: timeout message).
5. Turn Airplane mode **off**, tap **Retry Connection**: spinner, then the feed.
   No app restart.
6. Open a product: Hero flight, swipe the carousel (`1 / 3`, dots animate),
   tap the share icon, tap **Copy link** (button turns to "Copied").

## Likely instructor questions

**Why `as num` and not `as double`?**
JSON `100` decodes to `int`, `109.95` to `double`. `as double` throws a
TypeError on the int. `num` is the common parent, and `.toDouble()` normalises
both.

**Why a timeout?**
Without it a dead connection can hang the request indefinitely and the user
sees a spinner forever. With `.timeout(10s)` it throws `TimeoutException`,
which we turn into the error state.

**How does the Hero animation work?**
Both routes wrap the image in `Hero` with the same tag,
`product_image_${product.id}`. Flutter matches the tags during the route
transition and flies the widget between them.

**Why does `RefreshIndicator` need `AlwaysScrollableScrollPhysics`?**
If the list is shorter than the screen it is not scrollable, so there would be
nothing to pull. That physics keeps the overscroll gesture available.

**Why dispose the `PageController`?**
It holds a scroll position and listeners; not disposing leaks memory.

**404 vs 500?**
404 is a client-side problem (wrong URL / resource gone). 5xx is a server
failure. Both are caught and shown with a message; Retry is useful mostly for
5xx and network errors.

**How would a deep link actually open the app?**
Register an intent filter (Android) / URL scheme (iOS) for `narxoz://store`,
then parse the path with `go_router` or `onGenerateRoute`. The lab only
requires generating and copying the link.

```xml
<intent-filter>
  <action android:name="android.intent.action.VIEW"/>
  <category android:name="android.intent.category.DEFAULT"/>
  <category android:name="android.intent.category.BROWSABLE"/>
  <data android:scheme="narxoz" android:host="store"/>
</intent-filter>
```
