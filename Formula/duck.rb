class Duck < Formula
  desc "Command-line interface for Cyberduck (a multi-protocol file transfer tool)"
  homepage "https://duck.sh/"
  # check the changelog for the latest stable version: https://cyberduck.io/changelog/
  url "https://dist.duck.sh/duck-src-7.2.2.32045.tar.gz"
  sha256 "691409699811a954a65e0d2552e5de045c3eec5eac63366addac3bcec68b8e0a"
  head "https://svn.cyberduck.io/trunk/"

  bottle do
    cellar :any
    sha256 "a517e14bbb59820acef205d1df372af868002dc55a1ee29c829e34e8736bfb13" => :catalina
    sha256 "5d27cbfe0cfff2fc04800df01efef4b67382ce8c3a4a3374d168901ca8f303a2" => :mojave
    sha256 "4d3898df0283c3745a59cad6137dad9d88d1b8687e05d16bfaa26d6ae50bca25" => :high_sierra
  end

  depends_on "ant" => :build
  depends_on :java => ["1.8", :build]
  depends_on "maven" => :build
  depends_on :xcode => :build

  def install
    xcconfig = buildpath/"Overrides.xcconfig"
    xcconfig.write <<~EOS
      OTHER_LDFLAGS = -headerpad_max_install_names
    EOS
    ENV["XCODE_XCCONFIG_FILE"] = xcconfig
    revision = version.to_s.rpartition(".").last
    system "mvn", "-DskipTests", "-Dgit.commitsCount=#{revision}",
                  "--projects", "cli/osx", "--also-make", "verify"
    libexec.install Dir["cli/osx/target/duck.bundle/*"]
    bin.install_symlink "#{libexec}/Contents/MacOS/duck" => "duck"
  end

  test do
    system "#{bin}/duck", "--download", "https://ftp.gnu.org/gnu/wget/wget-1.19.4.tar.gz", testpath/"test"
    assert_equal (testpath/"test").sha256, "93fb96b0f48a20ff5be0d9d9d3c4a986b469cb853131f9d5fe4cc9cecbc8b5b5"
  end
end
