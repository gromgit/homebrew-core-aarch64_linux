class Meilisearch < Formula
  desc "Ultra relevant, instant and typo-tolerant full-text search API"
  homepage "https://docs.meilisearch.com/"
  url "https://github.com/meilisearch/MeiliSearch/archive/v0.10.0.tar.gz"
  sha256 "1421acf5a356b317f9730d7b9c8886dc93df672cf08bd59549f9470c93236164"

  bottle do
    cellar :any_skip_relocation
    sha256 "749963014898b2ba2120a148508edcf893da86da54bb8591d561c685572a6ab6" => :catalina
    sha256 "c3efbf506cefa9b34f7bb0fc12ac9443790961f9ac80afa49839c6f07fabe693" => :mojave
    sha256 "3e2e12d84f11f2a17333ca0e4e91ad1157145bee617cfcd6ef8927aad7a834bf" => :high_sierra
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--locked", "--root", prefix, "--path", "meilisearch-http"
  end

  test do
    output = shell_output("#{bin}/meilisearch --version")
    assert_match(/^meilisearch-http [0-9]*[.][0-9]*[.][0-9]*/, output)
  end
end
