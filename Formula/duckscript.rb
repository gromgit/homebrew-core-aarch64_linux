class Duckscript < Formula
  desc "Simple, extendable and embeddable scripting language"
  homepage "https://sagiegurari.github.io/duckscript"
  url "https://github.com/sagiegurari/duckscript/archive/0.8.0.tar.gz"
  sha256 "7632e1035e40ff41fc26667740d03ddabacff63f44ffc75b933804c0db9ba9f3"
  license "Apache-2.0"
  head "https://github.com/sagiegurari/duckscript.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "93b3f492e7203c29ea31176a9420435fa61048d723dc99c5db1c5a31e4dc6df5"
    sha256 cellar: :any_skip_relocation, big_sur:       "0b3b53ee5966eb8aa5689b53b437b65a6e061ab25aee614786b454f77b02ac9a"
    sha256 cellar: :any_skip_relocation, catalina:      "00e1044803cf8c53be2cd1664b6d108ed3fc6fbaed975b747594ab3bdcd83801"
    sha256 cellar: :any_skip_relocation, mojave:        "9498bf42096a26cc403a46ce13d3a28fed6de632dad50111964b370694d66fc3"
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
