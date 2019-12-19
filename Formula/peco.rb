class Peco < Formula
  desc "Simplistic interactive filtering tool"
  homepage "https://github.com/peco/peco"
  url "https://github.com/peco/peco/archive/v0.5.4.tar.gz"
  sha256 "06636082070634256b5adc4c24955ad2c520b24fec528131d0ce203c31aa209d"
  head "https://github.com/peco/peco.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "cc754e10e1b8c80ce328659814c4450f5b5fcfe8947dc1972631877b52ad3b19" => :catalina
    sha256 "d2a3d2950d81cf76b42950eba381f3359e0fa8c2b95829f8eb771013ff4cc4a1" => :mojave
    sha256 "653707beb0b04d448f7d4184213575df8a6ce138e42abff2861a98a8f1aa60b6" => :high_sierra
    sha256 "e4a10c067d24b7b790c9e522f9405cb5437d2b11837a3291ca2fd2ba00cfc253" => :sierra
    sha256 "80596ba0cbd75b50f01c31c406bb3fab28b7f0cffc9bb3e465a3dc6be1e56697" => :el_capitan
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/peco/peco").install buildpath.children
    cd "src/github.com/peco/peco" do
      system "make", "build"
      system "go", "build", "-o", bin/"peco", "cmd/peco/peco.go"
      prefix.install_metafiles
    end
  end

  test do
    system "#{bin}/peco", "--version"
  end
end
