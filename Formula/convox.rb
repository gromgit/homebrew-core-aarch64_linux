class Convox < Formula
  desc "Command-line interface for the Convox PaaS"
  homepage "https://convox.com/"
  url "https://github.com/convox/convox/archive/3.0.14.tar.gz"
  sha256 "3721f11628d43e7277bbefe64c91e7aa79b8e97c01c2ce338cf5f99028413562"
  version_scheme 1

  bottle do
    cellar :any_skip_relocation
    sha256 "05b43d58d6e7e156417534b573a765108daf33dfc2670afbc9e1e3d97abd4a97" => :catalina
    sha256 "90571c23e8167648c7b35dfc0a5af6db81b715a0890d9a77d2b78d8fe5400f7b" => :mojave
    sha256 "728bb6354c3c43bff8de2fcc5d297a959cbcb25214ad5fba0bdf746918176efc" => :high_sierra
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
