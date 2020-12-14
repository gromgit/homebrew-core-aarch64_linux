class Duckscript < Formula
  desc "Simple, extendable and embeddable scripting language"
  homepage "https://sagiegurari.github.io/duckscript"
  url "https://github.com/sagiegurari/duckscript/archive/0.7.1.tar.gz"
  sha256 "fb1c62df2d90a3cbe6efcc940e1a6494f9a26e68367f9c1ae28585f70824218d"
  license "Apache-2.0"
  head "https://github.com/sagiegurari/duckscript.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "1457ddea6906878bd2ce5b92483774dae364f5191a88465ad6aa1957cc2fccdf" => :big_sur
    sha256 "7894355ca12adb247fed4663b3eac885568db46b88f54bd92974387ceb73850f" => :catalina
    sha256 "f96b32b3e9dc6755af9e6b3852f7221408f6f0c45cb3caee3f0c05dd118b720a" => :mojave
  end

  depends_on "rust" => :build

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
