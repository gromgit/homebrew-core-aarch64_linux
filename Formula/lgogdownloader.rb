class Lgogdownloader < Formula
  desc "Unofficial downloader for GOG.com games"
  homepage "https://sites.google.com/site/gogdownloader/"
  url "https://github.com/Sude-/lgogdownloader/releases/download/v3.9/lgogdownloader-3.9.tar.gz"
  sha256 "d0b3b6198e687f811294abb887257c5c28396b5af74c7f3843347bf08c68e3d0"
  license "WTFPL"
  revision 2
  head "https://github.com/Sude-/lgogdownloader.git", branch: "master"

  livecheck do
    url :homepage
    regex(/href=.*?lgogdownloader[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "6f4d4d64703557f1018cf4b0595c4f94cf20ca87c28ac1ef30ede297eb8496f7"
    sha256 cellar: :any,                 arm64_big_sur:  "357f7864c9c768acf1fc99ed65c775aeec005ad8ceb54b749875f3aa2a27d658"
    sha256 cellar: :any,                 monterey:       "5cea761f4140103dfe67cdaf9d0c1ed5a217b9cffe171526b4aed71a496bdafe"
    sha256 cellar: :any,                 big_sur:        "267c486e488a1f0971c19d0ae47d2065447b2e247d842fa0fd4f46f03ec41462"
    sha256 cellar: :any,                 catalina:       "42b18160dbc356cdeb0e6b92a91d664d35ad6a731cbaa1397e9e5787efda4613"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "aa1532fab8b7dc8c0b109f9e7140747fb53827bcfc4034fec6cd73771e4961ca"
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

  uses_from_macos "curl"

  def install
    system "cmake", ".", *std_cmake_args, "-DJSONCPP_INCLUDE_DIR=#{Formula["jsoncpp"].opt_include}"

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
    lastline = ""
    begin
      reader.each_line { |line| lastline = line }
    rescue Errno::EIO
      # GNU/Linux raises EIO when read is done on closed pty
    end
    assert_equal "HTTP: Login failed", lastline.chomp
    reader.close
  end
end
