class SagittariusScheme < Formula
  desc "Free Scheme implementation supporting R6RS and R7RS"
  homepage "https://bitbucket.org/ktakashi/sagittarius-scheme/wiki/Home"
  url "https://bitbucket.org/ktakashi/sagittarius-scheme/downloads/sagittarius-0.9.8.tar.gz"
  sha256 "09d9c1a53abe734e09762a5f848888f0491516c09cd341a1f9c039cd810d32a2"
  license "BSD-2-Clause"
  revision 1

  bottle do
    rebuild 1
    sha256 cellar: :any,                 monterey:     "1300d4bd72c1346dbe1bc97b1c10b77f60ad4661bfd1e7d9a47144094f9d618d"
    sha256 cellar: :any,                 big_sur:      "23712f37ba7e82eccad3164e823c047b6530d20c016ec3e36e4619d26d7c61c8"
    sha256 cellar: :any,                 catalina:     "052b33c74e74a5a70c6f2c693263c51e4565eab9efc662b250eec00f2eb26537"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "5d717c5e87fd9d42f0d766a5b9bf7cc1076ef6e3a4458bf7aa787d1ae61bd886"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "bdw-gc"
  depends_on "openssl@1.1"
  depends_on "unixodbc"

  uses_from_macos "libffi", since: :catalina
  uses_from_macos "zlib"

  def install
    system "cmake", "-S", ".", "-B", "build", "-DODBC_LIBRARIES=odbc", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    assert_equal "4", shell_output("#{bin}/sagittarius -e '(display (+ 1 3))(exit)'")
  end
end
