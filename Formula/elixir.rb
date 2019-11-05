class Elixir < Formula
  desc "Functional metaprogramming aware language built on Erlang VM"
  homepage "https://elixir-lang.org/"
  url "https://github.com/elixir-lang/elixir/archive/v1.9.3.tar.gz"
  sha256 "08cf58ccaf38aa55f20ae436522ecce2bd666d680387202861582b4c9044cd4b"
  head "https://github.com/elixir-lang/elixir.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "27f40e039b45b90cd75f853b7a7725fcf3294de602ba3da1ce58ec5732547e4a" => :catalina
    sha256 "fa965f4da384b3e38ef8546847663d5f9552167d4f5a2dfbb0b86711670d03a8" => :mojave
    sha256 "1a5559f6cbbe647cf8a9063e680af4d6bfc5d3918f1688701706fadb45f45283" => :high_sierra
  end

  depends_on "erlang"

  def install
    system "make"
    bin.install Dir["bin/*"] - Dir["bin/*.{bat,ps1}"]

    Dir.glob("lib/*/ebin") do |path|
      app = File.basename(File.dirname(path))
      (lib/app).install path
    end

    system "make", "install_man", "PREFIX=#{prefix}"
  end

  test do
    system "#{bin}/elixir", "-v"
  end
end
