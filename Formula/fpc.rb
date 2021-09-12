class Fpc < Formula
  desc "Free Pascal: multi-architecture Pascal compiler"
  homepage "https://www.freepascal.org/"
  url "https://downloads.sourceforge.net/project/freepascal/Source/3.2.2/fpc-3.2.2.source.tar.gz"
  sha256 "d542e349de246843d4f164829953d1f5b864126c5b62fd17c9b45b33e23d2f44"
  license "GPL-2.0-or-later"
  revision 1

  # fpc releases involve so many files that the tarball is pushed out of the
  # RSS feed and we can't rely on the SourceForge strategy.
  livecheck do
    url "https://sourceforge.net/projects/freepascal/files/Source/"
    strategy :page_match
    regex(%r{href=(?:["']|.*?Source/)?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any, arm64_big_sur: "b4efbb9f568afadfb27aab8ca80895b7f306f58c7ff8a0623f2bd8418338b745"
    sha256 cellar: :any, big_sur:       "4c3a012398b6136776358206b0cac52ec1096484c27a08c142e7f51afc713956"
    sha256 cellar: :any, catalina:      "1bbaa4c1b6a616f8a56554b30c69cae267d22849074eb628d77c23af2e911e6e"
    sha256 cellar: :any, mojave:        "314265a7bff5c2f8a613d1c04db8856f6523d8d00d33435892260ef3fa9cc604"
  end

  resource "bootstrap" do
    url "https://downloads.sourceforge.net/project/freepascal/Mac%20OS%20X/3.2.2/fpc-3.2.2.intelarm64-macosx.dmg"
    sha256 "05d4510c8c887e3c68de20272abf62171aa5b2ef1eba6bce25e4c0bc41ba8b7d"
  end

  def install
    fpc_bootstrap = buildpath/"bootstrap"
    resource("bootstrap").stage do
      pkg_path = "fpc-3.2.2-intelarm64-macosx.mpkg/Contents/Packages/fpc-3.2.2-intelarm64-macosx.pkg"
      system "pkgutil", "--expand-full", pkg_path, "contents"
      (fpc_bootstrap/"fpc-3.2.2").install Dir["contents/Payload/usr/local/*"]
    end

    compiler_name = Hardware::CPU.arm? ? "ppca64" : "ppcx64"
    fpc_compiler = fpc_bootstrap/"fpc-3.2.2/bin"/compiler_name

    # Help fpc find the startup files (crt1.o and friends)
    sdk = MacOS.sdk_path_if_needed
    args = sdk ? %W[OPT="-XR#{sdk}"] : []

    system "make", "build", "PP=#{fpc_compiler}", *args
    system "make", "install", "PP=#{fpc_compiler}", "PREFIX=#{prefix}"

    bin.install_symlink lib/name/version/compiler_name

    # Prevent non-executable audit warning
    rm_f Dir[bin/"*.rsj"]

    # Generate a default fpc.cfg to set up unit search paths
    system "#{bin}/fpcmkcfg", "-p", "-d", "basepath=#{lib}/fpc/#{version}", "-o", "#{prefix}/etc/fpc.cfg"
  end

  test do
    hello = <<~EOS
      program Hello;
      uses GL;
      begin
        writeln('Hello Homebrew')
      end.
    EOS
    (testpath/"hello.pas").write(hello)
    system "#{bin}/fpc", "hello.pas"
    assert_equal "Hello Homebrew", shell_output("./hello").strip
  end
end
