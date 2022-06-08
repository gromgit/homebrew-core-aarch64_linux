class Quickjs < Formula
  desc "Small and embeddable JavaScript engine"
  homepage "https://bellard.org/quickjs/"
  url "https://bellard.org/quickjs/quickjs-2021-03-27.tar.xz"
  sha256 "a45bface4c3379538dea8533878d694e289330488ea7028b105f72572fe7fe1a"
  license "MIT"

  livecheck do
    url :homepage
    regex(/href=.*?quickjs[._-]v?(\d+(?:[.-]\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/quickjs"
    sha256 aarch64_linux: "911fa6a7dae26e86b4200681bc0569b092b0d6f8b6c74c37fe7e2992f5fcc5e7"
  end

  def install
    system "make", "install", "prefix=#{prefix}", "CONFIG_M32="
  end

  test do
    output = shell_output("#{bin}/qjs --eval 'const js=\"JS\"; console.log(`Q${js}${(7 + 35)}`);'").strip
    assert_match(/^QJS42/, output)

    path = testpath/"test.js"
    path.write "console.log('hello');"
    system "#{bin}/qjsc", path
    output = shell_output(testpath/"a.out").strip
    assert_equal "hello", output
  end
end
