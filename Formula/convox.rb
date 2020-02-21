class Convox < Formula
  desc "Command-line interface for the Convox PaaS"
  homepage "https://convox.com/"
  url "https://github.com/convox/convox/archive/3.0.14.tar.gz"
  sha256 "3721f11628d43e7277bbefe64c91e7aa79b8e97c01c2ce338cf5f99028413562"
  version_scheme 1

  bottle do
    cellar :any_skip_relocation
    sha256 "d14ea503227afd3e9d282da425cdbf05a0f6ffcd35b64e32ac8c0eae811015dd" => :catalina
    sha256 "1dda147d1c038555e10980ae23a89ef9c639827420c9a1b4645992d5786ac893" => :mojave
    sha256 "20bd6147a0bff746304784a96539aaa06cb5458ddfe41990d5be68b7c759f93a" => :high_sierra
  end

  depends_on "go" => :build

  resource "packr" do
    url "https://github.com/gobuffalo/packr/archive/v2.0.1.tar.gz"
    sha256 "cc0488e99faeda4cf56631666175335e1cce021746972ce84b8a3083aa88622f"
  end

  def install
    ENV["GOPATH"] = buildpath/"go"

    (buildpath/"src").install Dir["*"]

    resource("packr").stage { system "go", "install", "./packr" }

    cd buildpath/"src" do
      system "../go/bin/packr"
      system "go", "build", "-mod=vendor", "-ldflags=-X main.version=#{version}",
             "-o", bin/"convox", "-v", "./cmd/convox"
    end

    prefix.install_metafiles
  end

  test do
    assert_equal "Authenticating with localhost... ERROR: invalid login\n",
      shell_output("#{bin}/convox login -t invalid localhost 2>&1", 1)
  end
end
