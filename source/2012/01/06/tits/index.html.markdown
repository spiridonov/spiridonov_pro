---
date: 2012-01-06
slug: tits
title: Автоматизированная система управления сиськами
comments: true
language: ru
---

## Intro

Однажды я подумал, что постить сиськи в твиттер — это как-то несерьёзно.
Сиськи любят все. Но статусу единственного моего средства социального общения
это не соответствует:) Решил выделить под это отдельный аккаунт, а заодно
автоматизировать всё по-максимуму, чтобы не занимало много времени. Вполне
возможно, что есть готовые решения, но я хотел сделать, во-первых,
узконаправленное и простое, а во-вторых, было интересно поковыряться и
посмотреть, как оно работает (ну как обычно, короче:)).

## Twitter App

Я завёл отдельное сисечное мыло:) Может стоит печатать его на визитках?

<p><img src="/images/tits/google_apps.png"></p>

Затем зарегистрировал аккаунт [@SourceOfTits](http://twitter.com/SourceOfTits)
и одноимённое приложение. Здесь нет ничего сложного, разве что аватарку
пришлось поискать. Самое весёлое — дальше. От приложения нам сейчас
понадобится только Consumer key и Consumer secret.

<p><img src="/images/tits/twitter_app.png"></p>

## Консольное приложение

Начал с небольшого консольного приложения. Я взял любимый Python и тви-
библиотечку для него [tweepy](https://github.com/tweepy/tweepy). Идея проста:
сделать шорткат для замечательной программы Alfred. Открываешь Alfred, пишешь
ключевое слово tits и вставляешь из буфера ссылку на картинку. Alfred вызывает
консольную утилитку и передаёт в качестве параметра эту ссылку на картинку, и
затем она попадает в твиттер:)

Для начала нам понадобится авторизовать приложение, чтобы через него можно
было писать твиты в наш аккаунт. Для этого надо получить Access key и Access
secret. Эту часть я решил по-быстрому (чтобы с callback не заморачиваться)
сделать через pin-авторизацию:

    import sys
    import tweepy  

    CONSUMER_KEY = 'udyMtUvVw5Uo1hZR6PA2tg'
    CONSUMER_SECRET = 'GT0OG4fUNkio3eoWgfrVfWWFFlIGkoKReNxkeWAK6gw'  
    auth = tweepy.OAuthHandler(CONSUMER_KEY, CONSUMER_SECRET)
    auth_url = auth.get_authorization_url()
    print 'Please authorize: ' + auth_url
    verifier = raw_input('PIN: ').strip()
    auth.get_access_token(verifier)
    print "ACCESS_KEY = '%s'" % auth.access_token.key
    print "ACCESS_SECRET = '%s'" % auth.access_token.secret

Получаешь ссылку, вставляешь в браузер, видишь пин-код крупными цифрами,
копируешь, вставляешь - готово.

Сначала я решил, что неплохо было бы сокращать ссылки, чтобы выглядело всё
одинаково, красиво, и влазило. Для этого на bit.ly я зарегистрировал
приложение и получил login и api_key. Библиотечку я взял
[вот эту](http://code.google.com/p/python-bitly/). Потом внимательный @uzver
заметил, что сокращённые ссылки из тви-клиентов открываются в браузере из-за
неверного content-type. В будущем нужно либо найти сокращатель, который
картинки будет открывать как картинки, либо не пользоваться сокращателем
совсем.

    import sys
    import tweepy
    from bitly import bitly

    CONSUMER_KEY = 'udyMtUvVw5Uo1hZR6PA2tg'
    CONSUMER_SECRET = 'GT0OG4fUNkio3eoWgfrVfWWFFlIGkoKReNxkeWAK6gw'  
    ACCESS_KEY = '448741912-IvFTiKLHyE0d7lEKDIWPvOqiEhXF9sYluJnwyJYa'
    ACCESS_SECRET = 'NGVNOjMQ8H782c0obc1EPIHVw7ibUlzXGnxcXRY'  
    BITLY_LOGIN = 'sourceoftits'
    BITLY_API_KEY = 'R_6414284c699d9a6ab93c5ed69e57d6c8'  
    url = sys.argv[1]  
    bitlyApi = bitly.Api(login=BITLY_LOGIN, apikey=BITLY_API_KEY)
    short = bitlyApi.shorten(url)  
    auth = tweepy.OAuthHandler(CONSUMER_KEY, CONSUMER_SECRET)
    auth.set_access_token(ACCESS_KEY, ACCESS_SECRET)
    twitterApi = tweepy.API(auth)
    twitterApi.update_status(short)

## Сиськи в один клик

С Alfred всё работает отлично, однако всё равно надо делать много
телодвижений: делать правый клик, копировать, открывать альфреда, писать
ключевое слово и вставлять ссылку... Хочется проще — сделать это прямо из меню
браузера! Для этого я написал расширение для Chrome. Когда полез
[читать](http://code.google.com/chrome/extensions/overview.html) про
экстеншены, с ужасом обнаружил, что писать придётся на javascript:)

Начал, конечно же, с поиска готовых библиотек для JS. Есть, например,
официальная [@Anywhere](https://dev.twitter.com/docs/anywhere/welcome), но она
слишком навороченная и всё делает через визуальные элементы. Гугловые запросы
типа «post to twitter without twitbox from javascript» оказались очень
популярны. Народ тоже хочет твитить прямо из кода, без кнопок, и уж тем более
без попап окна самого твиттера.

Значит надо разобраться, как работает api твиттера на низком уровне, чтобы
потом воспроизвести это самому:) А там на самом деле всё просто. Большую часть
геморроя составляет OAuth авторизация. Чтобы запостить твит, нужно выполнить
[один POST запрос](https://dev.twitter.com/docs/api/1/post/statuses/update).

## OAuth

Для экспериментов я взял Python (ну потому что я нём уверен) и CURL.
Сравнивать, как обычно, я буду с эталоном — живым дампом:

    sudo tcpdump -w dump.txt -i en1 host api.twitter.com

Все параметры авторизации OAuth передаются в Authorization заголовке HTTP
запроса. Самым хитрым там является параметр oauth_signature - подпись,
генерируемая для каждого запроса. Она рассчитывается на основе случайного
токена, метки времени, параметров запроса и секретных ключей Access secret и
Consumer secret. Сначала инициализируем параметры, которые нам известны с
самого начала:

    parameters = {
      'status': 'test oauth',
      'oauth_token': ACCESS_KEY,
      'oauth_consumer_key': CONSUMER_KEY,
      'oauth_nonce': generate_nonce(),
      'oauth_signature_method': 'HMAC-SHA1',
      'oauth_timestamp': generate_timestamp(),
      'oauth_version': '1.0'
    }

Timestamp - это обычный UNIX-Timestamp в секундах, время запроса. Nonce -
случайный токен, может состоять из букв и цифр, длиной около 8-12 символов.
Генерировать его можно по своему усмотрению. Далее идут публичные ключи, метод
генерации подписи и версия протокола.

Сформируем строку, состоящую из названия HTTP метода, запрашиваемого URL и
всех параметров:

    key_values = [(escape(_utf8_str(k)), escape(_utf8_str(v))) for k,v in parameters.items()]
    key_values.sort()  
    param_str = '&'.join(['%s=%s' % (k, v) for k, v in key_values])  
    sig = (escape('POST'),
      escape('http://api.twitter.com/1/statuses/update.json'),
      escape(param_str))  
    key = '%s&%s' % (escape(CONSUMER_SECRET), escape(ACCESS_SECRET))
    raw = '&'.join(sig)

Здесь важно то, что параметры должны быть отсортированы в лексикографическом
порядке по имени. Все параметры и URL должны быть заэкранрованы. Соединяется
всё это добро через знак &.

Теперь строку raw нужно зашифровать выбранным алгоритмом с ключом key (в нашем
случае это SHA1) и зажать всё это добро в BASE64. Это и будет уникальная
подпись запроса. Заметьте, она включает, в том числе, в себя и текст самого
твита.

    try:
      import hashlib # 2.5
      hashed = hmac.new(key, raw, hashlib.sha1)
    except:
      import sha # Deprecated
      hashed = hmac.new(key, raw, sha)  
    print binascii.b2a_base64(hashed.digest())[:-1]

Подпись готова, теперь можно отправить запрос с помощью CURL. Как я уже
говорил, OAuth параметры идут в заголовке запроса, текст самого твита — в теле
запроса:

    curl -v -k --data-urlencode "status=test oauth" -H "Authorization: OAuth realm=\"\",
    oauth_nonce=\"21263329\", oauth_timestamp=\"1325857825\",
    oauth_consumer_key=\"udyMtUvVw5Uo1hZR6PA2tg\",
    oauth_signature_method=\"HMAC-SHA1\",
    oauth_signature=\"I5VM6P33vQ7q0aQxGRAsBTEEGUs%3D\",
    oauth_token=\"2448741912-IvFTiKLHyE0d7lEKDIWPvOqiEhXF9sYluJnwyJYa\",
    oauth_version=\"1.0\"" http://api.twitter.com/1/statuses/update.json

Отлично, работает! Теперь надо реализовать то же самое, но на javascript.

## Chrome Extension

Экстеншен состоит из манифеста, html, css, js файлов, картинок и прочей фигни.
Нам понадобится минимальный набор: манифест, html файл (чтобы заинклудить js
файл) и сам js файл с основным кодом. В manifest.json нужно указать имя,
описание, иконку, версию и права доступа:

    {
      "description" : "Source of tits",
      "background_page" : "background.html",
      "icons" : {
        "16" : "tits.png"
      },
      "name" : "tits | source of tits",
      "permissions" : [
        "http://*/*",
        "https://*/*",
        "contextMenus",
        "tabs"
      ],
      "version" : "0.1",
    }

background.html вообще получился смешной (а говорят, что можно и проще
сделать):

    <!DOCTYPE html>
    <html>
      <head>
        <title>Background Page</title>
      </head>
      <body>
        <script src="background.js"></script>
      </body>
    </html>

И, наконец, основной код background.js. Здесь всё аналогично питоновскому
коду. Обращу внимание на то, что указывать Content-Type нужно обязательно.
Отлаживать экстеншены можно прямо в консоли хрома. console.log() работает,
брейкпоинты тоже. Не забывайте только перезагружать эксеншен после каждого
изменения в коде (для этого есть специальная кнопка Перезагрузить на
chrome://settings/extensions#. Консоль, кстати, открывается оттуда же):

    var consumer_key = 'udyMtUvVw5Uo1hZR6PA2tg';
    var consumer_secret = 'GT0OG4fUNkio3eoWgfrVfWWFFlIGkoKReNxkeWAK6gw';
    var token = '448741912-IvFTiKLHyE0d7lEKDIWPvOqiEhXF9sYluJnwyJYa';
    var token_secret = 'NGVNOjMQ8H782c0obc1EPIHVw7ibUlzXGnxcXRY';  
    function oauthEscape(string) {
      //...
    };  
    function getNonce(length) {
      //...
    };  
    function getTimestamp() {
      //...
    };  
    function getParametersString(parameters) {
      var result = "";
      for (var p in parameters)
      {
        result += p + "=" + oauthEscape(parameters[p]) + "&";
      }
      return result.substring(0, result.length - 1);
    };  
    function b64_hmac_sha1(k, d, _p, _z) {
      //...
    }  
    function generateSignature(method, url, parameters) {
      var secretKey = consumer_secret + "&" + token_secret;  
      var sigString = oauthEscape(method) + "&" + oauthEscape(url) + "&" +
        oauthEscape(getParametersString(parameters));
      return b64_hmac_sha1(secretKey, sigString);
    };  
    function getHeaderString(parameters) {
      var result = 'OAuth realm=""';
      for (var p in parameters)
      {
        if (!p.match(/^oauth/)) {
          continue;
        }
        result += ', ' + p + '="' + oauthEscape(parameters[p]) + '"';
      }
      return result;
    };  
    function getClickHandler() {
      return function(info, tab) {
        var tits = info.srcUrl;  
        var method = "POST";
        var url = "https://api.twitter.com/1/statuses/update.json";
        var status = tits;  
        var parameters = {
          "oauth_consumer_key" : consumer_key,
          "oauth_nonce" : getNonce(),
          "oauth_signature_method" : "HMAC-SHA1",
          "oauth_timestamp" : getTimestamp(),
          "oauth_token" : token,
          "oauth_version" : "1.0",
          "status" : status
        };  
        var oauth_signature = generateSignature(method, url, parameters);  
        parameters["oauth_signature"] = oauth_signature;  
        var xhr = new XMLHttpRequest();
        xhr.onreadystatechange = function(data) {};
        xhr.open(method, url, true);
        xhr.setRequestHeader("Authorization", getHeaderString(parameters));
        xhr.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
        xhr.send("status=" + oauthEscape(status));
      };
    };  
    chrome.contextMenus.create({
      "title" : "Source of tits",
      "type" : "normal",
      "contexts" : ["image"],
      "onclick" : getClickHandler()
    });

## Outro

Всё ништяк! Немного разобрался с API, с OAuth, с расширениями для хрома,
забавную штуку в итоге сделал, да и вообще весело провёл время. А особенно
приятен был процесс тестирования - на сиськах:)

<p><img src="/images/tits/popup.png"></p>

