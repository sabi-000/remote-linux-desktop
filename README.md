# دسکتاپ لینوکسی راه دور روی Railway

این پروژه یک دسکتاپ XFCE را با image رسمی Webtop در یک کانتینر Railway اجرا می‌کند. دسترسی گرافیکی از طریق Webtop/KasmVNC و دامنه HTTPS انجام می‌شود؛ بنابراین Firefox داخل کانتینر اجرا می‌شود، نه روی رایانه محلی. داده‌های کاربر در Volume مسیر `/config` نگهداری می‌شوند.

## معماری

`Dockerfile` از `lscr.io/linuxserver/webtop:ubuntu-xfce` ساخته می‌شود. اسکریپت init، پوشه‌های کاربر و launcher Firefox را آماده می‌کند و XFCE آن را هنگام ورود اجرا می‌کند. سرویس داخلی Webtop تنها از طریق HTTPS و دامنه عمومی Railway در دسترس است و پورت خام VNC منتشر نمی‌شود.

## پیش‌نیازها

- حساب GitHub برای نگهداری repository
- حساب Railway برای build و deploy

## ساخت repository

یک repository با نام دلخواه در GitHub بسازید و فایل‌های این پروژه را با همین ساختار در آن قرار دهید، سپس commit و push کنید:

```bash
git init
git add .
git commit -m "Add Railway remote Linux desktop"
git branch -M main
git remote add origin https://github.com/USERNAME/REPOSITORY.git
git push -u origin main
```

## Deploy در Railway

1. در Railway گزینه **New Project** و سپس **Deploy from GitHub Repo** را انتخاب کنید.
2. repository را انتخاب کنید و اجازه دسترسی GitHub را در صورت درخواست بدهید.
3. Railway به‌صورت خودکار Dockerfile و `railway.toml` را شناسایی می‌کند؛ منتظر پایان build و deploy بمانید.
4. در سرویس ساخته‌شده، از بخش **Variables** مقادیر زیر را اضافه کنید:

| Variable | مقدار نمونه | کاربرد |
|---|---|---|
| `CUSTOM_USER` | `desktop` | نام کاربری ورود |
| `PASSWORD` | رمز قوی و یکتا | رمز ورود به دسکتاپ |
| `TZ` | `Asia/Tehran` | منطقه زمانی |
| `TITLE` | `Remote Linux Desktop` | عنوان نمایش‌داده‌شده |

رمز واقعی را فقط در Variables وارد کنید؛ آن را در GitHub، Dockerfile یا `railway.toml` ننویسید.

5. از بخش **Volumes** یک Volume بسازید و Mount Path را دقیقاً `/config` قرار دهید.
6. از بخش **Networking** گزینه **Generate Domain** را بزنید.
7. دامنه HTTPS را در مرورگر باز کنید و با `CUSTOM_USER` و `PASSWORD` وارد شوید.

بعد از هر `git push`، Railway باید به‌طور خودکار deploy جدید را آغاز کند.

## نکات امنیتی

- رمز طولانی، تصادفی و یکتا استفاده کنید.
- دامنه را عمومی منتشر نکنید و دسترسی آن را محدود نگه دارید.
- رمز را در GitHub، logها یا فایل‌های پروژه قرار ندهید.
- برای کار روزمره از حساب root در محیط گرافیکی استفاده نکنید؛ Webtop با کاربر پیش‌فرض image کار می‌کند.
- اطلاعات حساس را روی سرویس ابری نگهداری نکنید مگر اینکه ریسک و سیاست نگهداری Railway را پذیرفته باشید.

## Troubleshooting

### شکست build

لاگ build را بازبینی کنید، نام image و دسترسی repository را بررسی کنید و دوباره deploy کنید. اگر خطا از mirror یا apt بود، یک redeploy مجدد انجام دهید؛ image پایه باید در دسترس باشد.

### نبود Firefox ESR

Dockerfile پکیج `firefox-esr` را نصب می‌کند. اگر repository اوبونتو آن را ارائه نکند، اسکریپت به‌صورت امن از `firefox` موجود در image استفاده می‌کند و اگر هیچ‌کدام موجود نباشند، فقط هشدار می‌دهد.

### ریست شدن تنظیمات

نبودن Volume باعث می‌شود `/config` با redeploy یا جایگزینی کانتینر از بین برود. Volume را با Mount Path دقیق `/config` اضافه و متصل کنید.

### دامنه باز نمی‌شود

از موفق بودن deploy، آماده بودن service و وجود Public Domain در **Networking** مطمئن شوید. دامنه را با `https://` باز کنید و پورت VNC خام اضافه نکنید.

### مصرف RAM/CPU زیاد

تب‌های Firefox و برنامه‌های سنگین را ببندید، مصرف را در Metrics بررسی کنید و در صورت نیاز plan مناسب‌تری انتخاب کنید. Railway برای workload دسکتاپ سنگین مانند VPS سنتی طراحی نشده است.

Railway VPS سنتی نیست؛ کانتینر ممکن است در redeploy جایگزین شود. Volume برای حفظ تنظیمات و داده‌ها ضروری است.

## چک‌لیست نهایی

1. ساخت GitHub repository
2. افزودن فایل‌ها و push
3. اتصال repository به Railway
4. تنظیم Variables
5. افزودن Volume روی `/config`
6. Generate Domain
7. ورود به دسکتاپ با نام کاربری و رمز
