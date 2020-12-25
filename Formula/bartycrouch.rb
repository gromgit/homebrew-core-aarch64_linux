class Bartycrouch < Formula
  desc "Incrementally update/translate your Strings files"
  homepage "https://github.com/Flinesoft/BartyCrouch"
  url "https://github.com/Flinesoft/BartyCrouch.git",
      tag:      "4.3.2",
      revision: "35b819cb7575583c74a4d13ca4a91d829d1b8a7c"
  license "MIT"
  head "https://github.com/Flinesoft/BartyCrouch.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "4beaeea8854164db0603fa395b6dd2cb2bb2fda7eef05fe4f0a8eb1fd9bc61d4" => :big_sur
    sha256 "a36fc756f36d32789447ea2a80d3aa33576d507fe9f0496b910ebe7d2a54de19" => :arm64_big_sur
    sha256 "b5eff4af72a2cd5c45486d92e1c7e90c338f75f03a32284b526d79131923dc06" => :catalina
  end

  depends_on xcode: ["12.0", :build]

  def install
    system "make", "install", "prefix=#{prefix}"
  end

  test do
    (testpath/"Test.swift").write <<~EOS
      import Foundation

      class Test {
        func test() {
            NSLocalizedString("test", comment: "")
        }
      }
    EOS

    (testpath/"en.lproj/Localizable.strings").write <<~EOS
      /* No comment provided by engineer. */
      "oldKey" = "Some translation";
    EOS

    system bin/"bartycrouch", "update"
    assert_match /"oldKey" = "/, File.read("en.lproj/Localizable.strings")
    assert_match /"test" = "/, File.read("en.lproj/Localizable.strings")
  end
end
