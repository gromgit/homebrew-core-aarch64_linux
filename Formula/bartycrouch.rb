class Bartycrouch < Formula
  desc "Incrementally update/translate your Strings files"
  homepage "https://github.com/FlineDev/BartyCrouch"
  url "https://github.com/FlineDev/BartyCrouch.git",
      tag:      "4.10.2",
      revision: "8e12d831b2cb84c05c94a715815139e76f6a7b64"
  license "MIT"
  head "https://github.com/FlineDev/BartyCrouch.git", branch: "main"

  depends_on xcode: ["12.5", :build]
  depends_on :macos

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
    assert_match '"oldKey" = "', File.read("en.lproj/Localizable.strings")
    assert_match '"test" = "', File.read("en.lproj/Localizable.strings")
  end
end
