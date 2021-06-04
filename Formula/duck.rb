class Duck < Formula
  desc "Command-line interface for Cyberduck (a multi-protocol file transfer tool)"
  homepage "https://duck.sh/"
  url "https://dist.duck.sh/duck-src-7.9.3.35019.tar.gz"
  sha256 "2c58200b631a71846aa4d5b9bd5c19d7122c4d71a3765aed06b62cd4ffb8fc43"
  license "GPL-3.0-only"
  head "https://svn.cyberduck.io/trunk/"

  livecheck do
    url "https://dist.duck.sh/"
    regex(/href=.*?duck-src[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_big_sur: "bfc889c75061640485e6a71fcf98ab0db777b542fd235ed2df1d0007b7594c63"
    sha256 cellar: :any, big_sur:       "90fa3e9dbdc2c24ec89ba55bd709d1cef46fb0f35518a6991a8ee7ae26ac630d"
    sha256 cellar: :any, catalina:      "089548a2ebc431894b2edeb2d68919df0bf88d8ed4448e1bd8b457e40d93d07d"
    sha256 cellar: :any, mojave:        "892bc8e64173253e65432c760e635c7c179a679473c7d241d3d45b6b60136e0e"
  end

  depends_on "ant" => :build
  depends_on "maven" => :build
  depends_on xcode: :build

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
