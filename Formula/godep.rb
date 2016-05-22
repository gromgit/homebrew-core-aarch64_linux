class Godep < Formula
  desc "Dependency tool for go"
  homepage "https://godoc.org/github.com/tools/godep"
  url "https://github.com/tools/godep/archive/v70.tar.gz"
  sha256 "56f4947a89c48050318d4565ff454ac202cd3f2b5fd247fb4b7ed248917c2b17"
  head "https://github.com/tools/godep.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "d829572ba5be2cc2074791f1351ebc39004d2ece5f0a2a229f84d5d42b60a311" => :el_capitan
    sha256 "9865fffe21f5cbb95a0325ec703495ca610973fa69b3e1f421f4d73784e2aeb3" => :yosemite
    sha256 "03456e3a1fec11134968f724a53d431439e4f9244378815bbe0fefb2f070262f" => :mavericks
  end

  depends_on "go"

  def install
    ENV["GOPATH"] = buildpath
    mkdir_p buildpath/"src/github.com/tools/"
    ln_sf buildpath, buildpath/"src/github.com/tools/godep"

    cd "src/github.com/tools/godep" do
      system "go", "build", "-o", bin/"godep"
    end
  end

  test do
    ENV["GO15VENDOREXPERIMENT"] = "0"
    mkdir "Godeps"
    (testpath/"Godeps/Godeps.json").write <<-EOS.undent
      {
        "ImportPath": "github.com/tools/godep",
        "GoVersion": "go1.6",
        "Deps": []
      }
    EOS
    system bin/"godep", "path"
  end
end
