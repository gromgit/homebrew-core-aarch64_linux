class PrqlCompiler < Formula
  desc "Simple, powerful, pipelined SQL replacement"
  homepage "https://prql-lang.org"
  url "https://github.com/prql/prql/archive/refs/tags/0.2.6.tar.gz"
  sha256 "4079d5f505250e6fe071215499b21e8ac7ecea23b55a16a4054bc5bf5707faf6"
  license "Apache-2.0"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/prql-compiler"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "76759672ed1e11ae7dee5a4e317bf3645055a75de04a4fddad74c3fb49a32df5"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "prql-compiler")
  end

  test do
    stdin = "from employees | filter has_dog | select salary"
    stdout = pipe_output("#{bin}/prql-compiler compile", stdin)
    assert_match "SELECT", stdout
  end
end
