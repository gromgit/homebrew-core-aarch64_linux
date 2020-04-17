class Lgogdownloader < Formula
  desc "Unofficial downloader for GOG.com games"
  homepage "https://sites.google.com/site/gogdownloader/"
  url "https://sites.google.com/site/gogdownloader/lgogdownloader-3.7.tar.gz"
  sha256 "984859eb2e0802cfe6fe76b1fe4b90e7354e95d52c001b6b434e0a9f5ed23bf0"

  bottle do
    cellar :any
    sha256 "5e70091768d53a815135dcc4bed8cc6e0ff059bc45474570b96fabedce3fc4a6" => :catalina
    sha256 "767486fb7d6ba4c26c91de77fababebc1e56f1db7810139b0f2f0de02ebd3583" => :mojave
    sha256 "368e0b5873a6881a71a9416fba2ae7d54a930b34dc27adcfbed0b7cd32a9453f" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "help2man" => :build
  depends_on "pkg-config" => :build
  depends_on "boost"
  depends_on "htmlcxx"
  depends_on "jsoncpp"
  depends_on "liboauth"
  depends_on "rhash"
  depends_on "tinyxml2"

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    require "pty"

    ENV["XDG_CONFIG_HOME"] = testpath
    reader, writer = PTY.spawn(bin/"lgogdownloader", "--list", "--retries", "1")
    writer.write <<~EOS
      test@example.com
      secret
    EOS
    writer.close
    assert_equal "HTTP: Login failed", reader.read.lines.last.chomp
    reader.close
  end
end
