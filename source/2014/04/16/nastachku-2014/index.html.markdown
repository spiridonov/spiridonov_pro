---
title: "Отчет со Стачки 2014"
title_image: nastachku-2014/title.jpg
date: 2014-04-16
slug: nastachku-2014
comments: true
language: ru
description: Отчет о конференции На Стачку 2014. Мы послушали интересные доклады на технической секции, забойно потусили на афтепати, познакомились и пообщались с клевыми ребятами.
---

На днях мы с [@alexgorkunov](http://twitter.com/alexgorkunov) съездили в Ульяновск на Стачку. Да, от нашей большой компании всего два человека – народ как-то не очень горит желанием ездить на конференции. А мы-то в Ульяновск ездим часто – на Стачки, на RailsClub'ы и т.д. – уже, можно сказать, специалисты по Ульяновску:)

Мы приехали в четверг поздно вечером, заселились в Апельсин и легли спать. В пятницу утром выдвинулись на место. Весь день ходили по залам, общались, слушали доклады. На официальное афтепати решили не ходить, вместо этого устроили свое собственное с блэкджеком и алкоголем. В большой компании замечательных мальчиков и девочек, преимущественно местных, мы сначала рефакторили столы в ирландском пабе JP, затем обкатали [новую кафешку](http://vk.com/hubcafe) Юры Бушмелева, а потом поехали барагозить в Техас. Конечно же, я проснулся утром вовремя и один пошел на доклады. Так всегда происходит, мои коллеги после афтепати просыпаются только к обеду.

## Доклады

Булат Каримов из Яндекса рассказал об Островах и real-time взаимодействии поисковика с сайтами. Можно создать свой остров и показывать пользователю классный виджет прямо на экране поисковой выдачи. От простых виджетов с дополнительной информацией об адресе и телефоне до сложной формы, которая позволит искать товары на сайте.

Андрей Аксенов пришел с докладом, который делал на HighLoad (и потом на RitConf), про внутренности NoSQL. Нового почти ничего не придумали – за кадром трудится тот же btree. Веселые слайды со схемами btree, LSM и других структур данных, нарисованные от руки в блокноте, угар и подколы – вобщем нормальный доклад в духе Аксенова. Жалко по времени не уложился.

Варгейминг скупают всё и вся. А еще они пишут на Python, считают все на сервере, обрабатывают более миллиона запросов в секунду и генерируют 6 петабайт трафика при раздаче обновлений.

Саша Чистяков из Git in Sky веселил всех рассказом о его суровых буднях смотрителя за огромной PostgreSQL базой. Многое разобрали на цитаты.

Ребята из 2Гис переписали все на JS. Теперь они реюзают код и на сервере и на клиенте, выдают полные странички поисковикам, а грамотно изоливанные и мелко порезанные виджеты позволяют собирать приложение из кубиков и тестировать по частям.

<p><img src="/images/nastachku-2014/2.jpg" class="center"/></p>

Коля Рыжиков рассказал о работе со сложной предметной областью (это больная для меня тема). К сожалению времени у него не хватило. В основном все шло вокруг подхода DDD и книжки Эрика Эванса. Я книжку читал и с подходом немного знаком. Жаль у нас на проекте больше нет людей в теме, поэтому идет все тяжело. Хочу больше общения на эту тему!

Застал часть доклада Быкова из RedKeds. Сейчас модно перемещать все в офлайн, т.к. люди получают удовольствие от общения с другими живыми людьми, а не от просмотра роликов или другого одностороннего взаимодействия. Вобщем, придумывайте квесты, сажайте людей в прозрачные тюрьмы прямо в торговых центрах, путешествуйте и общайтесь с людьми.

Еманов Дмитрий из Firebird рассказал о WAL логе (и его отсутствии), восстановлении после падений, о легком версионировании схем базы данных и о том, что все уже было в ~~Симпсонах~~ Firebird.

Ребята из Aviasales переписали все на ангуляре и выкинули рельсы. В следующем году ждем больше лулзов и рассказ о react.js, ага. Странно, в этом году вроде никого не хантили.

Кирилл Смородинников из Яндекса показал всем Эллиптикс и Кокаин. Но мы-то не первый день замужем – мы уже слышали ранее про это на других ивентах от Яндекса.

Юра Бушмелев опять рассказал о жизни сисадмина. Как хорошо, что я не админ:)

Олег Бартунов два дня бомбил всех рассказами о PostgreSQL, сначала о новых фишках версии 9.4, а затем хардкором об индексах, расширениях и планах запросов. Я каждый раз, слушая такие рассказы о тонкостях баз данных, плачу от того, сколько всего я упускаю, спрятавшись за ORM:)

<p><img src="/images/nastachku-2014/1.jpg" class="center"/></p>

## Фидбэк к организаторам

_Я тут поворчу немного, но не обижайтесь – это я исключительно с целью улучшить процесс в будущем. Вообще мы отлично провели время и обязательно приедем в следующий раз._

Наше утро началось с длинной очереди у входа в здание. Оказалось, внутри люди просто долго не могли найти свой бейджик. Сложно искать бейджик в куче из двух тысяч. Вообще, их не надо искать – их надо печатать на месте. Это единственно правильное решение на конференции для более чем 200 человек, а уж тем более пары тысяч. Например, на последнем YaC было 5000 человек, бейджи печатались очаровательными девушками прямо на стойке регистрации по предъявлению штрихкода. Крайне быстро и удобно.

Найти бейджик было только началом. Затем мы долго искали залы. В программке, конечно, была красивая трехмерная карта, но ориентироваться по ней было сложно. Залы были подписаны, но указатели стояли только в непосредственной близости к залу и не на всех этажах. Самый простой выход – ставить везде указатели на все залы, а не только на самый ближайший.

И еще я снова скажу про раздатку. Раздатка – это мусор. Ее никто не читает, и она обычно сразу же летит в мусорное ведро. Не тратьте деньги на ее изготовление и не засоряйте планету. Возмите пример с того же YaC – там кроме бейджика ничего не было. Лучше сделайте мобильное приложение с расписанием и раздайте всем воды, хотя бы на утро второго дня – люди будут вам реально благодарны.

Техническую секцию явно недооценили. Маленькие залы не вмещали всех жаждущих услышать доклады. Особенно грустно было в Первой Аудитории. В прошлом году была голосовалка на сайте, это помогает примерно оценить число зрителей. Еще можно просто посчитать по графе _профессия_ в профилях участников: _инженеры_ и _программисты_ маловероятно пойдут на digital доклады.

## Всем спасибо

Увидимся на Стачке в следующем году. Или в этом году на RailsClub... Или еще где нибудь:)
