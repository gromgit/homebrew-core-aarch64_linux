class Elixir < Formula
  desc "Functional metaprogramming aware language built on Erlang VM"
  homepage "https://elixir-lang.org/"
  url "https://github.com/elixir-lang/elixir/archive/v1.10.1.tar.gz"
  sha256 "bf10dc5cb084382384d69cc26b4f670a3eb0a97a6491182f4dcf540457f06c07"
  head "https://github.com/elixir-lang/elixir.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "086572927b0ae7cecfbad39ed9231db201b32a9229f17f928e2bda96d17d5419" => :catalina
    sha256 "3b8caa1aaa5e09b4a4e031e70b63e008a212c51df5e9d76b9bb1cce4eeca101d" => :mojave
    sha256 "2425dfe5c15c51794a92b744e5373bfb64f32874524441e91bc67420e53348f5" => :high_sierra
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
