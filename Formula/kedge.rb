class Kedge < Formula
  desc "Deployment tool for Kubernetes artifacts"
  homepage "https://github.com/kedgeproject/kedge"
  url "https://github.com/kedgeproject/kedge/archive/v0.12.0.tar.gz"
  sha256 "3c01880ba9233fe5b0715527ba32f0c59b25b73284de8cfb49914666a158487b"
  license "Apache-2.0"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/kedge"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "66d04340b2c73419ad44f41490b7362bbf11b6a70364a767e6c55dc0ec5d62fa"
  end

  # https://github.com/kedgeproject/kedge/issues/619
  deprecate! date: "2021-02-21", because: :unsupported

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    ENV["GO111MODULE"] = "auto"
    (buildpath/"src/github.com/kedgeproject").mkpath
    ln_s buildpath, buildpath/"src/github.com/kedgeproject/kedge"
    system "make", "bin"
    bin.install "kedge"
  end

  test do
    (testpath/"kedgefile.yml").write <<~EOS
      name: test
      deployments:
      - containers:
        - image: test
    EOS
    output = shell_output("#{bin}/kedge generate -f kedgefile.yml")
    assert_match "name: test", output
  end
end
