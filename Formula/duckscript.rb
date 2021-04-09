class Duckscript < Formula
  desc "Simple, extendable and embeddable scripting language"
  homepage "https://sagiegurari.github.io/duckscript"
  url "https://github.com/sagiegurari/duckscript/archive/0.8.1.tar.gz"
  sha256 "2ff56f80ed1d57a7fffc1f09b9fd7481a79d7815c7947cbff5e746f819f1aa3a"
  license "Apache-2.0"
  head "https://github.com/sagiegurari/duckscript.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "a2d128203160905a2bc11a0865c65ac55a8a84aaac41291d972659a29560530a"
    sha256 cellar: :any_skip_relocation, big_sur:       "467601d561fc88e1ed8d04d8578fe1d7e0aa787a2aa79725b06997c4ff6c1606"
    sha256 cellar: :any_skip_relocation, catalina:      "be38be5a2ac8be096aad74d435e8f5afe27078507be14999782f7d937b349487"
    sha256 cellar: :any_skip_relocation, mojave:        "815654c60404277f05dc7bb04791b80f166386696734a30a9c204df3044cc6c9"
  end

  depends_on "rust" => :build

  uses_from_macos "openssl@1.1"

  on_linux do
    depends_on "pkg-config" => :build
  end

  def install
    cd "duckscript_cli" do
      system "cargo", "install", *std_cargo_args
    end
  end

  test do
    (testpath/"hello.ds").write <<~EOS
      out = set "Hello World"
      echo The out variable holds the value: ${out}
    EOS
    output = shell_output("#{bin}/duck hello.ds")
    assert_match "The out variable holds the value: Hello World", output
  end
end
