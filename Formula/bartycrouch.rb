class Bartycrouch < Formula
  desc "Incrementally update/translate your Strings files"
  homepage "https://github.com/Flinesoft/BartyCrouch"
  url "https://github.com/Flinesoft/BartyCrouch.git",
      :tag      => "4.1.0",
      :revision => "be2404129aa6141b00a2e7fd61e7dd8ab088d1d6"
  head "https://github.com/Flinesoft/BartyCrouch.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "646f4137bf311a052f14e25c0221e3c6f1b8a007a491a6a01fe76777e2c4d7ae" => :catalina
  end

  depends_on :xcode => ["11.4", :build]

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
