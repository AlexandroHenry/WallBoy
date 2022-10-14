//
//  StockCurrentViewModel.swift
//  WallBoy
//
//  Created by Seungchul Ha on 2022/09/20.
//

import Foundation

class StockInfoViewModel: ObservableObject {
    @Published var stockInfo = StockInfo()
    
    func fetch(symbol: String) {
        let urlString = "http://131.186.28.79/stockInfo/symbol=\(symbol)"

        guard let url = URL(string: urlString) else { return }
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            guard let data = data, error == nil else {
                return
            }
            
            do {
                let stockInfo = try JSONDecoder().decode(StockInfo.self, from: data)
                let info = stockInfo
    
                DispatchQueue.main.sync {
                    self!.stockInfo = info
                }
            } catch {
                print(error)
            }
        }
        task.resume()
    }
}

// MARK: - StockInfo
struct StockInfo: Codable {
//    var defaultKeyStatistics: DefaultKeyStatistics
//    var summaryProfile: SummaryProfile
    var recommendationTrend: RecommendationTrend
    var financialsTemplate: FinancialsTemplate
    var earnings: StockInfoEarnings
    var price: Price
    var financialData: FinancialData
    var quoteType: QuoteType
    var calendarEvents: CalendarEvents
    var summaryDetail: SummaryDetail
    var symbol: String
//    var esgScores: EsgScores
    var upgradeDowngradeHistory: UpgradeDowngradeHistory
    var pageViews: PageViews
    
    init() {
//        defaultKeyStatistics = DefaultKeyStatistics()
//        summaryProfile = SummaryProfile()
        recommendationTrend = RecommendationTrend()
        financialsTemplate = FinancialsTemplate()
        earnings = StockInfoEarnings()
        price = Price()
        financialData = FinancialData()
        quoteType = QuoteType()
        calendarEvents = CalendarEvents()
        summaryDetail = SummaryDetail()
        symbol = ""
//        esgScores = EsgScores()
        upgradeDowngradeHistory = UpgradeDowngradeHistory()
        pageViews = PageViews()
    }
}

// MARK: - CalendarEvents
struct CalendarEvents: Codable {
    var maxAge: Int
    var earnings: CalendarEventsEarnings
    
    init() {
        maxAge = 0
        earnings = CalendarEventsEarnings()
    }
}

// MARK: - CalendarEventsEarnings
struct CalendarEventsEarnings: Codable {
    var earningsDate: [Int]
    var earningsAverage, earningsLow, earningsHigh: Double
    var revenueAverage, revenueLow, revenueHigh: Int
    
    init() {
        earningsDate = [0, 1]
        earningsAverage = 0
        earningsLow = 0
        earningsHigh = 0
        revenueAverage = 0
        revenueLow = 0
        revenueHigh = 0
    }
}

// MARK: - DefaultKeyStatistics
struct DefaultKeyStatistics: Codable {
    var enterpriseToRevenue: Double
    var profitMargins, enterpriseToEbitda, the52WeekChange: Double
    var forwardEps: Double
    var sharesOutstanding: Int
    var bookValue: Double
    var sharesShort: Int
    var sharesPercentSharesOut: Double
    var lastFiscalYearEnd: Int
    var heldPercentInstitutions: Double
    var netIncomeToCommon: Int
    var trailingEps, sandP52WeekChange, priceToBook: Double
    var heldPercentInsiders: Double
    var nextFiscalYearEnd: Int
    var mostRecentQuarter: Int
    var shortRatio: Double
    var sharesShortPreviousMonthDate, floatShares: Int
    var enterpriseValue, priceHint: Int
    var dateShortInterest: Int
    var pegRatio: Double
    var forwardPE: Double
    var maxAge: Int
    var sharesShortPriorMonth, impliedSharesOutstanding: Int

    enum CodingKeys: String, CodingKey {
        case enterpriseToRevenue, profitMargins, enterpriseToEbitda
        case the52WeekChange = "52WeekChange"
        case forwardEps, sharesOutstanding, bookValue, sharesShort, sharesPercentSharesOut, lastFiscalYearEnd, heldPercentInstitutions, netIncomeToCommon, trailingEps
        case sandP52WeekChange = "SandP52WeekChange"
        case priceToBook, heldPercentInsiders, nextFiscalYearEnd, mostRecentQuarter, shortRatio, sharesShortPreviousMonthDate, floatShares, enterpriseValue, priceHint, dateShortInterest, pegRatio, forwardPE, maxAge, sharesShortPriorMonth, impliedSharesOutstanding
    }
    
    init() {
        enterpriseToRevenue = 0
        profitMargins = 0
        enterpriseToEbitda = 0
        the52WeekChange = 0
        forwardEps = 0
        sharesOutstanding = 0
        bookValue = 0
        sharesShort = 0
        sharesPercentSharesOut = 0
        lastFiscalYearEnd = 0
        heldPercentInstitutions = 0
        netIncomeToCommon = 0
        trailingEps = 0
        sandP52WeekChange = 0
        priceToBook = 0
        heldPercentInsiders = 0
        nextFiscalYearEnd = 0
        mostRecentQuarter = 0
        shortRatio = 0
        sharesShortPreviousMonthDate = 0
        floatShares = 0
        enterpriseValue = 0
        priceHint = 0
        dateShortInterest = 0
        pegRatio = 0
        forwardPE = 0
        maxAge = 0
        sharesShortPriorMonth = 0
        impliedSharesOutstanding = 0
    }
}

// MARK: - StockInfoEarnings
struct StockInfoEarnings: Codable {
    var maxAge: Int
    var earningsChart: EarningsChart
    var financialsChart: FinancialsChart
    var financialCurrency: String
    
    init() {
        maxAge = 0
        earningsChart = EarningsChart()
        financialsChart = FinancialsChart()
        financialCurrency = ""
    }
}

// MARK: - EarningsChart
struct EarningsChart: Codable {
    var quarterly: [EarningsChartQuarterly]
    var currentQuarterEstimate: Double
    var currentQuarterEstimateDate: String
    var currentQuarterEstimateYear: Int
    var earningsDate: [Int]
    
    init() {
        quarterly = [EarningsChartQuarterly()]
        currentQuarterEstimate = 0
        currentQuarterEstimateDate = ""
        currentQuarterEstimateYear = 0
        earningsDate = [0, 1, 2]
    }
}

// MARK: - EarningsChartQuarterly
struct EarningsChartQuarterly: Codable {
    var date: String
    var actual, estimate: Double
    
    init() {
        date = ""
        actual = 0
        estimate = 0
    }
}

// MARK: - FinancialsChart
struct FinancialsChart: Codable {
    var yearly: [Yearly]
    var quarterly: [FinancialsChartQuarterly]
    
    init(){
        yearly = [Yearly()]
        quarterly = [FinancialsChartQuarterly()]
    }
}

// MARK: - FinancialsChartQuarterly
struct FinancialsChartQuarterly: Codable {
    var date: String
    var revenue, earnings: Int
    
    init() {
        date = ""
        revenue = 0
        earnings = 0
    }
}

// MARK: - Yearly
struct Yearly: Codable {
    var date, revenue, earnings: Int
    
    init() {
        date = 0
        revenue = 0
        earnings = 0
    }
}



// MARK: - PeerPerformance
struct PeerPerformance: Codable {
    var min, avg, max: Double
    
    init() {
        min = 0
        avg = 0
        max = 0
    }
}

// MARK: - FinancialData
struct FinancialData: Codable {
    var currentPrice: Double
    
    init() {
        currentPrice = 0
    }
}

// MARK: - FinancialsTemplate
struct FinancialsTemplate: Codable {
    var code: String
    var maxAge: Int
    
    init() {
        code = ""
        maxAge = 0
    }
}

// MARK: - PageViews
struct PageViews: Codable {
    var shortTermTrend, midTermTrend, longTermTrend: String
    var maxAge: Int
    
    init() {
        shortTermTrend = ""
        midTermTrend = ""
        longTermTrend = ""
        maxAge = 0
    }
}

// MARK: - Price
struct Price: Codable {
    var regularMarketOpen: Double
    var averageDailyVolume3Month: Int
    var exchange: String
    var regularMarketTime: Int
    var regularMarketDayHigh: Double
    var shortName: String
    var averageDailyVolume10Day: Int
    var longName: String
    var regularMarketChange: Double
    var currencySymbol: String
    var regularMarketPreviousClose: Double
    var exchangeDataDelayedBy: Int
    var exchangeName: String
    var regularMarketDayLow: Double
    var priceHint: Int
    var currency: String
    var regularMarketPrice: Double
    var regularMarketVolume: Int
    var regularMarketSource: String
    var marketState: String
    var marketCap: Int
    var quoteType: String
    var symbol: String
    var preMarketSource: String
    var maxAge: Int
    var regularMarketChangePercent: Double
    
    init() {
        regularMarketOpen = 0
        averageDailyVolume3Month = 0
        exchange = ""
        regularMarketTime = 0
        regularMarketDayHigh = 0
        shortName = ""
        averageDailyVolume10Day = 0
        longName = ""
        regularMarketChange = 0
        currencySymbol = ""
        regularMarketPreviousClose = 0
        exchangeDataDelayedBy = 0
        exchangeName = ""
        regularMarketDayLow = 0
        priceHint = 0
        currency = ""
        regularMarketPrice = 0
        regularMarketVolume = 0
        regularMarketSource = ""
        marketState = ""
        marketCap = 0
        quoteType = ""
        symbol = ""
        preMarketSource = ""
        maxAge = 0
        regularMarketChangePercent = 0
    }
}

// MARK: - QuoteType
struct QuoteType: Codable {
    var exchange, shortName, longName, exchangeTimezoneName: String
    var exchangeTimezoneShortName: String
    var isEsgPopulated: Bool
    var gmtOffSetMilliseconds, quoteType, symbol, messageBoardID: String
    var market: String

    enum CodingKeys: String, CodingKey {
        case exchange, shortName, longName, exchangeTimezoneName, exchangeTimezoneShortName, isEsgPopulated, gmtOffSetMilliseconds, quoteType, symbol
        case messageBoardID = "messageBoardId"
        case market
    }
    
    init() {
        exchange = ""
        shortName = ""
        longName = ""
        exchangeTimezoneName = ""
        exchangeTimezoneShortName = ""
        isEsgPopulated = false
        gmtOffSetMilliseconds = ""
        quoteType = ""
        symbol = ""
        messageBoardID = ""
        market = ""
    }
}

// MARK: - RecommendationTrend
struct RecommendationTrend: Codable {
    var trend: [Trend]
    var maxAge: Int
    
    init() {
        trend = [Trend()]
        maxAge = 0
    }
}

// MARK: - Trend
struct Trend: Codable {
    var period: String
    var strongBuy, buy, hold, sell: Int
    var strongSell: Int
    
    init() {
        period = ""
        strongBuy = 0
        buy = 0
        hold = 0
        sell = 0
        strongSell = 0
    }
}

// MARK: - SummaryDetail
struct SummaryDetail: Codable {
    var previousClose, regularMarketOpen, twoHundredDayAverage, trailingAnnualDividendYield: Double
    var regularMarketDayHigh: Double
    var averageDailyVolume10Day: Int
    var regularMarketPreviousClose, fiftyDayAverage, trailingAnnualDividendRate, summaryDetailOpen: Double
    var averageVolume10Days: Int
    var regularMarketDayLow: Double
    var priceHint: Int
    var currency: String
    var trailingPE: Double
    var regularMarketVolume: Int
    var marketCap: Int
    var averageVolume: Int
    var dayLow, ask: Double
    var askSize, volume: Int
    var fiftyTwoWeekHigh, forwardPE: Double
    var maxAge: Int
    var fiftyTwoWeekLow, bid: Double
    var tradeable: Bool
    var bidSize: Int
    var dayHigh: Double
    
    init() {
        previousClose = 0
        regularMarketOpen = 0
        twoHundredDayAverage = 0
        trailingAnnualDividendYield = 0
        regularMarketDayHigh = 0
        averageDailyVolume10Day = 0
        regularMarketPreviousClose = 0
        fiftyDayAverage = 0
        trailingAnnualDividendRate = 0
        summaryDetailOpen = 0
        averageVolume10Days = 0
        regularMarketDayLow = 0
        priceHint = 0
        currency = ""
        trailingPE = 0
        regularMarketVolume = 0
        marketCap = 0
        averageVolume = 0
        dayLow = 0
        ask = 0
        askSize = 0
        volume = 0
        fiftyTwoWeekHigh = 0
        forwardPE = 0
        maxAge = 0
        fiftyTwoWeekLow = 0
        bid = 0
        tradeable = false
        bidSize = 0
        dayHigh = 0
    }

    enum CodingKeys: String, CodingKey {
        case previousClose, regularMarketOpen, twoHundredDayAverage, trailingAnnualDividendYield, regularMarketDayHigh, averageDailyVolume10Day, regularMarketPreviousClose, fiftyDayAverage, trailingAnnualDividendRate
        case summaryDetailOpen = "open"
        case averageVolume10Days = "averageVolume10days"
        case regularMarketDayLow, priceHint, currency, trailingPE, regularMarketVolume, marketCap, averageVolume, dayLow, ask, askSize, volume, fiftyTwoWeekHigh, forwardPE, maxAge, fiftyTwoWeekLow, bid, tradeable, bidSize, dayHigh
    }
}

// MARK: - SummaryProfile
struct SummaryProfile: Codable {
    var zip, sector: String
    var fullTimeEmployees: Int
    var longBusinessSummary, city, phone: String
    var country: String
    var website: String
    var maxAge: Int
    var address1, industry: String
    
    init() {
        zip = ""
        sector = ""
        fullTimeEmployees = 0
        longBusinessSummary = ""
        city = ""
        phone = ""
        country = ""
        website = ""
        maxAge = 0
        address1 = ""
        industry = ""
    }
}

// MARK: - UpgradeDowngradeHistory
struct UpgradeDowngradeHistory: Codable {
    var history: [History]
    var maxAge: Int
    
    init() {
        history = [History()]
        maxAge = 0
    }
}

// MARK: - History
struct History: Codable {
    var epochGradeDate: Int
    var firm: String
    var toGrade, fromGrade: String
    var action: String
    
    init() {
        epochGradeDate = 0
        firm = ""
        toGrade = ""
        fromGrade = ""
        action = ""
    }
}
