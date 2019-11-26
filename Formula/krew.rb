class Krew < Formula
  desc "Package manager for kubectl plugins"
  homepage "https://krew.dev"
  url "https://github.com/kubernetes-sigs/krew/archive/v0.3.2.tar.gz"
  sha256 "c1807bdf1f504061a75cce67874529533f511aa02a09e313684f2e507f1dd195"

  bottle do
    cellar :any_skip_relocation
    sha256 "12e9c700fe97d7dd9f1915e3580546fda931d3cdaee92933fc5c15911b7e8e06" => :catalina
    sha256 "847c972d50416a282fed6decb2197fd90c5b6c10b13ecfaa17f64f718710d8b1" => :mojave
    sha256 "befe73340dabe8740284be78a1282957c94d29a6d845a0f3766e99eab543be5d" => :high_sierra
  end

  depends_on "go" => :build
  depends_on "kubernetes-cli"

  def install
    ENV["CGO_ENABLED"] = "0"
    # build in local dir to avoid this error:
    # go build: cannot write multiple packages to non-directory /usr/local/Cellar/krew/0.3.2/bin/krew
    mkdir "build"
    system "go", "build", "-o", "build", "-tags", "netgo", "./cmd/krew/..."
    # install as kubectl-krew for kubectl to find as plugin
    bin.install "build/krew" => "kubectl-krew"
  end

  test do
    system "#{bin}/kubectl-krew", "version"
  end
end
