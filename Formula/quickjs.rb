class Quickjs < Formula
  desc "Small and embeddable JavaScript engine"
  homepage "https://bellard.org/quickjs/"
  url "https://bellard.org/quickjs/quickjs-2020-11-08.tar.xz"
  sha256 "2e9d63dab390a95ed365238f21d8e9069187f7ed195782027f0ab311bb64187b"
  license "MIT"

  bottle do
    sha256 "a1f998b9825902b58cbc9fff5dfbb3b7fa3cff70bdb00d5518c124c7fb241dda" => :catalina
    sha256 "bd0b90ea85294d55896f668c2079112606052c6695e8b419b874d98198b5d69c" => :mojave
    sha256 "d21f88599b0f002f71b477be73f48a5ca9faaa32f3696faf647d1ce416a2fcec" => :high_sierra
  end

  def install
    system "make", "install", "prefix=#{prefix}", "CONFIG_M32="
  end

  test do
    output = shell_output("#{bin}/qjs --eval 'const js=\"JS\"; console.log(`Q${js}${(7 + 35)}`);'").strip
    assert_match /^QJS42/, output

    path = testpath/"test.js"
    path.write "console.log('hello');"
    system "#{bin}/qjsc", path
    output = shell_output(testpath/"a.out").strip
    assert_equal "hello", output
  end
end
