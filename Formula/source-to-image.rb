class SourceToImage < Formula
  desc "Tool for building source and injecting into docker images"
  homepage "https://github.com/openshift/source-to-image"
  url "https://github.com/openshift/source-to-image.git",
      :tag      => "v1.3.0",
      :revision => "eed2850f2187435ef5d83487e05bf3dc18622ceb"
  revision 1
  head "https://github.com/openshift/source-to-image.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "8e977cfd4aff9c6867f74ce430187857f8f2a37d33c672d8e45b885005a4d181" => :catalina
    sha256 "568e6d711462191b0bc8629ad0c69bd24967fa83f1b0dcfcce9aee1e42dbdfd7" => :mojave
    sha256 "eabf5777a98f3e6e363ae664e0d19002bd92722ca980d3d119bde4dfcb9c921b" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "hack/build-go.sh"
    bin.install "_output/local/bin/darwin/amd64/s2i"
  end

  test do
    system "#{bin}/s2i", "create", "testimage", testpath
    assert_predicate testpath/"Dockerfile", :exist?, "s2i did not create the files."
  end
end
