class SwiftSh < Formula
  desc "Scripting with easy zero-conf dependency imports"
  homepage "https://github.com/mxcl/swift-sh"
  url "https://github.com/mxcl/swift-sh/archive/1.17.1.tar.gz"
  sha256 "90c2d8ca708922fdb36b26d81dac768183ff65f0cd00698937fb89435c53dcfb"
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
