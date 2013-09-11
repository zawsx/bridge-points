`import Card from "appkit/models/card"`
`import Hand from "appkit/models/hand"`
`import Constants from "appkit/utils/constants"`

DummyHand = Ember.Object.extend
  hand: (->
    Hand.create
      id: @get("id")
      cards: @get("cards")
  ).property("deal", "cards.@each")

  trump: (->
    suit = @get("bid")[1..-1]
    if suit == "NT" then null else suit
  ).property("bid")

  trumpCards: (->
    @get("hand.cards").filterBy("suit", @get("trump"))
  ).property("trump", "hand.cards.@each")

  dummy: (->
    @get("hand.starter") + @get("shortSuits")
  ).property("hand", "shortSuits")

  shortSuits: (->
    result = 0
    Constants.SUITS.without(@get("trump")).forEach (suit) =>
      cardsInSuit = @get("hand.cards").filterBy("suit", suit)
      result += switch cardsInSuit.get("length")
        when 0 then @get("trumpCards.length")
        when 1
          if @get("trumpCards.length") >= 4 then 3 else 2
        when 2 then 1
        else
          0
    if result > @get("trumpCards.length") then @get("trumpCards.length") else result
  ).property("hand.cards.@each", "trump", "trumpCards.@each")

`export default DummyHand`
