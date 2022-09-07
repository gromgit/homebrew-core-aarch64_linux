class Tofrodos < Formula
  desc "Converts DOS <-> UNIX text files, alias tofromdos"
  homepage "https://www.thefreecountry.com/tofrodos/"
  url "https://tofrodos.sourceforge.io/download/tofrodos-1.7.13.tar.gz"
  sha256 "3457f6f3e47dd8c6704049cef81cb0c5a35cc32df9fe800b5fbb470804f0885f"
  license "GPL-2.0"

  livecheck do
    url :homepage
    regex(/href=.*?tofrodos[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/tofrodos"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "3788b9051e98bba90d4020e3d15365d1bf693dd53460dce6c066421c2fbbd31a"
  end

  def install
    cd "src" do
      system "make"
      bin.install %w[todos fromdos]
      man1.install "fromdos.1"
      man1.install_symlink "fromdos.1" => "todos.1"
    end
  end
end
