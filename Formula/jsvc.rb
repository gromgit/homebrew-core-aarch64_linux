class Jsvc < Formula
  desc "Wrapper to launch Java applications as daemons"
  homepage "https://commons.apache.org/daemon/jsvc.html"
  url "https://www.apache.org/dyn/closer.lua?path=commons/daemon/source/commons-daemon-1.3.1-src.tar.gz"
  mirror "https://archive.apache.org/dist/commons/daemon/source/commons-daemon-1.3.1-src.tar.gz"
  sha256 "492737a1cb9b09f06366dc941e9084eab0e417b52d0005ac5086bd7d0d601edb"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "eaab68414a0b2baa923b44d8586f1fbf1a425d37c06870ca4e063dffa2bbb933"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "43261838f40f1df64555476046fffb114742f7399297bdc414e9a177e87872f0"
    sha256 cellar: :any_skip_relocation, monterey:       "b04c71b4afdd14a4e1867af564ebe444f44a1204b6b4615a4868d33ba85ed0cf"
    sha256 cellar: :any_skip_relocation, big_sur:        "de514757fbeafe3d8dbaeb1f4d097380c4b017d6e10937862f625f4c3968f75f"
    sha256 cellar: :any_skip_relocation, catalina:       "5c7308e3495ffd2af09ac54f61df59a9ce3aa46899a96a1d4ab125f27149e5d3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "34999c468ea8a823fd2dd6a27a9ddd25a863a3c536e980f1a66d9e36745a3622"
  end

  depends_on "openjdk"

  def install
    prefix.install %w[NOTICE.txt LICENSE.txt RELEASE-NOTES.txt]

    cd "src/native/unix" do
      system "./configure", "--with-java=#{Formula["openjdk"].opt_prefix}"
      system "make"

      libexec.install "jsvc"
      (bin/"jsvc").write_env_script libexec/"jsvc", Language::Java.overridable_java_home_env
    end
  end

  test do
    output = shell_output("#{bin}/jsvc -help")
    assert_match "jsvc (Apache Commons Daemon)", output
  end
end
