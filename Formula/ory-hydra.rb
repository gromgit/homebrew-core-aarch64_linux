class OryHydra < Formula
  desc "OpenID Certified OAuth 2.0 Server and OpenID Connect Provider"
  homepage "https://www.ory.sh/hydra/"
  url "https://github.com/ory/hydra/archive/v1.6.0.tar.gz"
  sha256 "d7deda97dc869aa0ae406614ff2776b79504c47cee282bd02fe002f7cf02cc41"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "f9e1c364d45b83b7013ae48efb6d785c44a7286b755443926a4de3d16132d1a4" => :catalina
    sha256 "a96797c6f94d2ae341d23866b76c7e09b390dcaf61aa8064806e193b7645aeac" => :mojave
    sha256 "04bf760fdd26360a93226340bb9a681534924a9d84b46e9298f601793ac44a21" => :high_sierra
  end

  depends_on "go" => :build

  conflicts_with "hydra", because: "both install `hydra` binaries"

  def install
    ENV["GOBIN"] = bin
    system "make", "install"
  end

  test do
    admin_port = free_port
    (testpath/"config.yaml").write <<~EOS
      dsn: memory
      serve:
        public:
          port: #{free_port}
        admin:
          port: #{admin_port}
    EOS

    fork { exec bin/"hydra", "serve", "all", "--config", "config.yaml" }
    sleep 5

    endpoint = "https://127.0.0.1:#{admin_port}/"
    output = shell_output("#{bin}/hydra clients list --endpoint #{endpoint} --skip-tls-verify")
    assert_match "| CLIENT ID |", output
  end
end
