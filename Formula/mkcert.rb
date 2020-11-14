class Mkcert < Formula
  desc "Simple tool to make locally trusted development certificates"
  homepage "https://github.com/FiloSottile/mkcert"
  url "https://github.com/FiloSottile/mkcert/archive/v1.4.2.tar.gz"
  sha256 "4b43f21a37263355fc0cfd5305c88312e333e4401bc48710d25fbcf9dbb46540"
  license "BSD-3-Clause"

  bottle do
    cellar :any_skip_relocation
    sha256 "a0023269070477df87289064633f853364647506073d1c27eaca3559e7397bf2" => :big_sur
    sha256 "5dc54c06caf0211bc7819f2bcfeb845413e1ef0ddab54df5eed93fc0be27212e" => :catalina
    sha256 "2c6ad2f96bdd13b45a69c4fe204bcec5c7194d2dc3a48b88654164cafc47ec67" => :mojave
    sha256 "041291da4a29bd7a44cd1c727079efa5af699d6e90f088cdd11abfe347a86d2f" => :high_sierra
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = HOMEBREW_CACHE/"go_cache"
    (buildpath/"src/github.com/FiloSottile/mkcert").install buildpath.children

    cd "src/github.com/FiloSottile/mkcert" do
      system "go", "build", "-o", bin/"mkcert", "-ldflags", "-X main.Version=v#{version}"
      prefix.install_metafiles
    end
  end

  test do
    ENV["CAROOT"] = testpath
    system bin/"mkcert", "brew.test"
    assert_predicate testpath/"brew.test.pem", :exist?
    assert_predicate testpath/"brew.test-key.pem", :exist?
    output = (testpath/"brew.test.pem").read
    assert_match "-----BEGIN CERTIFICATE-----", output
    output = (testpath/"brew.test-key.pem").read
    assert_match "-----BEGIN PRIVATE KEY-----", output
  end
end
