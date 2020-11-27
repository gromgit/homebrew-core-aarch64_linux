class Sourcery < Formula
  desc "Meta-programming for Swift, stop writing boilerplate code"
  homepage "https://github.com/krzysztofzablocki/Sourcery"
  url "https://github.com/krzysztofzablocki/Sourcery/archive/1.0.1.tar.gz"
  sha256 "3e748d21094fd8a44b7488a2f969218ba03a532213a2b9c9a80a547dae9b4db2"
  license "MIT"
  head "https://github.com/krzysztofzablocki/Sourcery.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "cd3f236b56f12c1c5ed4192dd0657fb376108661369b11fd7b3f28c7af70941b" => :big_sur
    sha256 "cc2c763bf9ceb6ac2825a746f5a4b8c0bcfde28973f73682c2e60943bd206256" => :catalina
  end

  depends_on xcode: "12.0"

  def install
    system "swift", "build", "--disable-sandbox", "-c", "release", "-Xswiftc",
                             "-target", "-Xswiftc", "x86_64-apple-macosx10.11"
    bin.install ".build/release/sourcery"
    lib.install Dir[".build/release/*.dylib"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/sourcery --version").chomp
  end
end
