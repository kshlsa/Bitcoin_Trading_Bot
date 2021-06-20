library(magrittr)
library(plotly)
library(quantmod)
library(dplyr)
library(DescTools)
library(devtools)
install_github("daroczig/binancer")
library(binancer)

key <- '9xPDRgiucoNi78TlCN939BNsTaL5TAKpNFE6A9vij2FkefpPfA5WnKsgIk0i0cuQ'
secret <- 'uNfD4oQT4mODPo0XlqegCfdOZ46e2BSQf9cchKUxEpF48xz5q8NVyzz0qNA9pcsI'

binance_ping()
binance_credentials(key, secret)

data <- binance_klines('BTCUSDT', interval = '5m')

precioBTC <- binance_coins_prices(unit = "USDT")  %>%
  filter(symbol == "BTC")
precioBTC$usd

head(data)
str(data)
x <- data$open_time
y <- data %>% dplyr::select(open, high, low, close) %>% as.matrix()

# Candlestick

data %>% plot_ly(x = data$open_time, type="candlestick",
                 open = data$open, close = data$close,
                 high = data$high, low = data$low) %>%
  layout(title = "Candlestick Chart")

# MACD

macd <- MACD(data[,"close"], 12, 26, 9, maType="EMA" )
macd

# MACD as data frame

macd1 <- as.data.frame(macd)

# RSI 

rsi <- RSI(data$close, n = 14, maType = "SMA")

# RSI as data frame

rsi1 <- as.data.frame(rsi)

# Candlestick with MACD and RSI

chartSeries(data,theme=chartTheme('black'))
addMACD(fast=12,slow=26,signal=9,type="EMA")
addRSI(data$close, n = 14, maType = "SMA")