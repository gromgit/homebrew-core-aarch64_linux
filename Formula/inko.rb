class Inko < Formula
  desc "Safe and concurrent object-oriented programming language"
  homepage "https://inko-lang.org/"
  url "https://releases.inko-lang.org/0.9.0.tar.gz"
  sha256 "311f6e675e6f7ca488a71022b62edbbc16946f907d7e1695f3f96747ece2051f"
  license "MPL-2.0"
  head "https://gitlab.com/inko-lang/inko.git"

  bottle do
    cellar :any
    sha256 "41ab1fbef244bc9d59410946f6887a9b3e26a7a2c042d0802b3446c2a82ce5a1" => :big_sur
    sha256 "50e59361460408563479d63cc5d884c8336371463a7da8f72019d38a27408bee" => :catalina
    sha256 "ac5c0017a6565b937a3dc367ccb6bccd9b57c5c710f70641160109c4f32fc3f1" => :mojave
  end

  depends_on "coreutils" => :build
  depends_on "make" => :build
  depends_on "rust" => :build
  depends_on "libffi"

  uses_from_macos "ruby", since: :sierra

  def install
    make = Formula["make"].opt_bin/"gmake"
    system make, "build", "PREFIX=#{libexec}", "FEATURES=libinko/libffi-system"
    system make, "install", "PREFIX=#{libexec}"
    bin.install Dir[libexec/"bin/*"]
  end

  test do
    (testpath/"hello.inko").write <<~EOS
      import std::stdio::stdout

      stdout.print('Hello, world!')
    EOS
    assert_equal "Hello, world!\n", shell_output("#{bin}/inko hello.inko")
  end
end
