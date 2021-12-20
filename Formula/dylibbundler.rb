class Dylibbundler < Formula
  desc "Utility to bundle libraries into executables for macOS"
  homepage "https://github.com/auriamg/macdylibbundler"
  url "https://github.com/auriamg/macdylibbundler/archive/1.0.3.tar.gz"
  sha256 "84e37c6884b71a6d40d99202729dfc21479d53a82a343488f1d5378f0561d615"
  license "MIT"
  head "https://github.com/auriamg/macdylibbundler.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2cf3e58dd1749774265a74e36af79478846bc5a3fa0e5724d69a78737690112a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "40125dd27d6f811634eec64ab52d976e3a947be6e52d9fabffb1e0d9bbb7fc18"
    sha256 cellar: :any_skip_relocation, monterey:       "eeaf6008b6bfd14b06f79119ccd293efece269d2ecd5205f31f3a9b629af3ec8"
    sha256 cellar: :any_skip_relocation, big_sur:        "19d1732659993aa63b90deea1f1040b7553a187aa8c7ed8aec7becc92a79cedf"
    sha256 cellar: :any_skip_relocation, catalina:       "21a58715ba2040c03d7fad30a7313fc2696daf74085266458fddab9911b02c62"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "eaa4413ac0b2704431675aab23f314f12b98598595775e98aa5f9d15e67f3a2f"
  end

  def install
    system "make"
    bin.install "dylibbundler"
  end

  test do
    system "#{bin}/dylibbundler", "-h"
  end
end
