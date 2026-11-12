import SwiftUI

struct Poem: Identifiable, Hashable {
    let id: Int
    let title: String
    let author: String
    let theme: String
    let lines: [String]
    let note: String
    let symbol: String

    static let library: [Poem] = [
        Poem(id: 1, title: "靜夜思", author: "李白", theme: "月色", lines: ["床前明月光，", "疑是地上霜。", "舉頭望明月，", "低頭思故鄉。"], note: "月光落在床前，像一層薄霜。抬頭與低頭之間，眼前的風景成了心中的故鄉。這首詩用最簡單的動作，寫出遊子難以說出口的想念。", symbol: "moon.stars"),
        Poem(id: 2, title: "山居秋暝", author: "王維", theme: "山水", lines: ["空山新雨後，天氣晚來秋。", "明月松間照，清泉石上流。", "竹喧歸浣女，蓮動下漁舟。", "隨意春芳歇，王孫自可留。"], note: "雨後的山林清新安靜，月光與泉水帶來明亮的層次。浣女與漁舟的聲響，讓山居不只是空寂，更有生活的溫度。詩人願意留下，也是一種對自在生活的選擇。", symbol: "mountain.2"),
        Poem(id: 3, title: "春曉", author: "孟浩然", theme: "四季", lines: ["春眠不覺曉，", "處處聞啼鳥。", "夜來風雨聲，", "花落知多少。"], note: "先聽見鳥聲，才察覺春日已經天亮。詩人由昨夜的風雨想到落花，讓醒來的喜悅裡帶著一點惜春的心情。試著閉上眼睛，從聲音想像這個清晨。", symbol: "leaf"),
        Poem(id: 4, title: "登鸛雀樓", author: "王之渙", theme: "山水", lines: ["白日依山盡，", "黃河入海流。", "欲窮千里目，", "更上一層樓。"], note: "落日與黃河把視野推向遠方；最後兩句又把觀看變成行動。想看見更遼闊的世界，就再向上走一步。短短四句，從風景寫到人的志向。", symbol: "sun.horizon"),
        Poem(id: 5, title: "鹿柴", author: "王維", theme: "山水", lines: ["空山不見人，", "但聞人語響。", "返景入深林，", "復照青苔上。"], note: "看不見人，卻聽得到遠處的聲音；幽暗的林中，又有夕陽照亮青苔。聲音與光線讓寂靜變得可以感受。讀這首詩，可以把速度放慢，留意那些很小的變化。", symbol: "tree"),
        Poem(id: 6, title: "江雪", author: "柳宗元", theme: "四季", lines: ["千山鳥飛絕，", "萬徑人蹤滅。", "孤舟蓑笠翁，", "獨釣寒江雪。"], note: "千山、萬徑的遼闊，最後收束成江上的一葉孤舟。大片空白讓漁翁的身影格外鮮明。寒冷與孤獨之外，也能讀到一種不隨環境動搖的堅持。", symbol: "snowflake"),
        Poem(id: 7, title: "相思", author: "王維", theme: "思念", lines: ["紅豆生南國，", "春來發幾枝？", "願君多採擷，", "此物最相思。"], note: "小小的紅豆成了寄託想念的物件。詩人沒有直接說出離別的難過，而是溫柔地叮嚀對方多採一些。日常事物，也能保存一段深刻的感情。", symbol: "heart"),
        Poem(id: 8, title: "宿建德江", author: "孟浩然", theme: "月色", lines: ["移舟泊煙渚，", "日暮客愁新。", "野曠天低樹，", "江清月近人。"], note: "暮色讓旅人的愁緒重新浮現。曠野中，天空彷彿低過樹梢；清澈江面上的月影，卻像在身旁相伴。從遠到近的視線，讓孤單得到了一點安慰。", symbol: "water.waves")
    ]
}

@Observable
final class ReadingStore {
    #if DEBUG
    var demoShowsNotes = false
    #endif
    var favorites: Set<Int> {
        didSet { UserDefaults.standard.set(Array(favorites), forKey: "favoritePoems") }
    }
    init() { favorites = Set(UserDefaults.standard.array(forKey: "favoritePoems") as? [Int] ?? []) }
    func toggle(_ poem: Poem) {
        if favorites.contains(poem.id) { favorites.remove(poem.id) }
        else { favorites.insert(poem.id) }
    }
}

enum Ink {
    static let background = Color(red: 0.05, green: 0.11, blue: 0.15)
    static let card = Color(red: 0.09, green: 0.17, blue: 0.20)
    static let gold = Color(red: 0.89, green: 0.76, blue: 0.51)
    static let paper = Color(red: 0.95, green: 0.91, blue: 0.81)
}
