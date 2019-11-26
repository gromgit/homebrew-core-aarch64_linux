class Duck < Formula
  desc "Command-line interface for Cyberduck (a multi-protocol file transfer tool)"
  homepage "https://duck.sh/"
  # check the changelog for the latest stable version: https://cyberduck.io/changelog/
  url "https://dist.duck.sh/duck-src-7.2.0.31900.tar.gz"
  sha256 "a189634cb4897e4678de8eaa4d06ba4dfe7049b43165f390568ab87f8a673877"
  head "https://svn.cyberduck.io/trunk/"

  bottle do
    cellar :any
    sha256 "a3dba53b383cdd570fcec5b8c8d010d1fcd86180ddca46abdc767a07e4f524d9" => :mojave
    sha256 "9e16a3e6263dfaf668e42a8a214e9bc0cad7109eceabd03764f72748ccf3f44f" => :high_sierra
    sha256 "ed2b7813acecdcd36f8c1a1bf1223315abcdb19d7f8fc9954b5f99f09347e6d1" => :sierra
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
