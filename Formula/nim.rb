class Nim < Formula
  desc "Statically typed compiled systems programming language"
  homepage "https://nim-lang.org/"
  url "https://nim-lang.org/download/nim-1.2.0.tar.xz"
  sha256 "4e94583a373965821805e665e0a05f52fb610916676edb09148941415637c575"

  bottle do
    cellar :any_skip_relocation
    sha256 "dd4e05e5d208a4ec3cc1b7ca3232761f1891c5663fade15015fce3d5f637835b" => :catalina
    sha256 "f6ad64fdbde925ccb9f72d28e4f419697097142b9d838fddb1d0086c89cc6f45" => :mojave
    sha256 "ae72dd3da7385276d636295aff9c31d670273c93504d9e65a2da107594256aad" => :high_sierra
  end

  head do
    url "https://github.com/nim-lang/Nim.git", :branch => "devel"
    resource "csources" do
      url "https://github.com/nim-lang/csources.git"
    end
  end

  def install
    if build.head?
      resource("csources").stage do
        system "/bin/sh", "build.sh"
        (buildpath/"bin").install "bin/nim"
      end
    else
      system "/bin/sh", "build.sh"
    end
    # Compile the koch management tool
    system "bin/nim", "c", "-d:release", "koch"
    # Build a new version of the compiler with readline bindings
    system "./koch", "boot", "-d:release", "-d:useLinenoise"
    # Build nimble/nimgrep/nimpretty/nimsuggest
    system "./koch", "tools"
    system "./koch", "geninstall"
    system "/bin/sh", "install.sh", prefix

    target = prefix/"nim/bin"
    bin.install_symlink target/"nim"
    tools = %w[nimble nimgrep nimpretty nimsuggest]
    tools.each do |t|
      target.install buildpath/"bin"/t
      bin.install_symlink target/t
    end
  end

  test do
    (testpath/"hello.nim").write <<~EOS
      echo("hello")
    EOS
    assert_equal "hello", shell_output("#{bin}/nim compile --verbosity:0 --run #{testpath}/hello.nim").chomp

    (testpath/"hello.nimble").write <<~EOS
      version = "0.1.0"
      author = "Author Name"
      description = "A test nimble package"
      license = "MIT"
      requires "nim >= 0.15.0"
    EOS
    assert_equal "name: \"hello\"\n", shell_output("#{bin}/nimble dump").lines.first
  end
end
