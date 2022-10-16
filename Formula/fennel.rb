class Fennel < Formula
  desc "Lua Lisp Language"
  homepage "https://fennel-lang.org"
  url "https://github.com/bakpakin/Fennel/archive/1.2.1.tar.gz"
  sha256 "fae8a0b00275529acb3785673b9505f378786ccd2cd2bc16254f6a5fd08e0d19"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d4915471c4f52fe963468da35c79079d7db0cdef08a3c09be811687e54ec29f9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c00667b3e84013c67b6e251dff2c091baf6599b48bb4ff787a761f0dd1be0f5e"
    sha256 cellar: :any_skip_relocation, monterey:       "9aace69fdc70c35aaa9f08ed825f9f7be9cace850c8a305584b0e223bf90f0fa"
    sha256 cellar: :any_skip_relocation, big_sur:        "7c53cf4aa6c9f7b5ccbb6bd40722a0ce636ee8881aef386d03a60025b3226b05"
    sha256 cellar: :any_skip_relocation, catalina:       "7fa35cabbdbea8df9c43565e97fb13f402914279c0933a129b6719a7d88504b3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1e6a49be68d5c396cc2142ee954855cd4970abae8a35af6e7e7988915b0eb41d"
  end

  depends_on "lua"

  def install
    system "make"
    bin.install "fennel"

    lua = Formula["lua"]
    (share/"lua"/lua.version.major_minor).install "fennel.lua"
  end

  test do
    assert_match "hello, world!", shell_output("#{bin}/fennel -e '(print \"hello, world!\")'")
  end
end
