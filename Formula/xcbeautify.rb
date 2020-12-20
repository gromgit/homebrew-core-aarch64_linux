class Xcbeautify < Formula
  desc "Little beautifier tool for xcodebuild"
  homepage "https://github.com/thii/xcbeautify"
  url "https://github.com/thii/xcbeautify.git",
      tag:      "0.9.0",
      revision: "105251c21b9b70d4f9c31001d6375df858081ba7"
  license "MIT"
  head "https://github.com/thii/xcbeautify.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "05387bb5adaec4a508dd0b9a0f52210a481900d8be9ce2696a37c67add4f3901" => :big_sur
    sha256 "a263117ddff2a44a586920f96249030b176b9d718d9b985e08b7fe6c0e9d4b51" => :catalina
  end

  depends_on xcode: ["11.4", :build]

  def install
    system "swift", "build", "--disable-sandbox", "--configuration", "release"
    bin.install ".build/release/xcbeautify"
  end

  test do
    log = "CompileStoryboard /Users/admin/MyApp/MyApp/Main.storyboard (in target: MyApp)"
    assert_match "[\u{1B}[36mMyApp\u{1B}[0m] \u{1B}[1mCompiling\u{1B}[0m Main.storyboard",
      pipe_output("#{bin}/xcbeautify", log).chomp
    assert_match version.to_s,
      shell_output("#{bin}/xcbeautify --version").chomp
  end
end
