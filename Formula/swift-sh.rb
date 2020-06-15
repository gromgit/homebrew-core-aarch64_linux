class SwiftSh < Formula
  desc "Scripting with easy zero-conf dependency imports"
  homepage "https://github.com/mxcl/swift-sh"
  url "https://github.com/mxcl/swift-sh/archive/1.18.0.tar.gz"
  sha256 "e65b43609d43cc9163ef11d4a2b46e9f5f9387a6fd1645ed6ede5aac24333066"
  head "https://github.com/mxcl/swift-sh.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "7cc9e2b7184a01b5271d7bcc9b6e6e11361e41dd1dec3bb720ad98000cde827d" => :catalina
    sha256 "e30adca6e2e45dd7c47eeeff3118316ad05585fbfa3828b44643a6319d3e8c81" => :mojave
    sha256 "5672c1000adbcb0e97e2c1fcdc60469c5979648082a1e23bb93176b5435930d9" => :high_sierra
  end

  depends_on :xcode => ["10.0", :build]

  def install
    system "swift", "build", "--disable-sandbox", "-c", "release"
    bin.install ".build/release/swift-sh"
    bin.install ".build/release/swift-sh-edit"
  end

  test do
    (testpath/"test.swift").write "#!/usr/bin/env swift sh"
    system "#{bin}/swift-sh", "eject", "test.swift"
    assert_predicate testpath/"Test"/"Package.swift", :exist?
  end
end
