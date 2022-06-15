class TitanServer < Formula
  desc "Distributed graph database"
  homepage "https://thinkaurelius.github.io/titan/"
  url "http://s3.thinkaurelius.com/downloads/titan/titan-1.0.0-hadoop1.zip"
  version "1.0.0"
  sha256 "67538e231db5be75821b40dd026bafd0cd7451cdd7e225a2dc31e124471bb8ef"

  livecheck do
    url "https://github.com/thinkaurelius/titan.git"
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/titan-server"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "19e267cd2547a537935ce119a0734e36b8bf62c92d21f997834e219a96640f89"
  end

  def install
    libexec.install %w[bin conf data ext javadocs lib log scripts]
    bin.install_symlink libexec/"bin/titan.sh" => "titan"
    bin.install_symlink libexec/"bin/gremlin.sh" => "titan-gremlin"
    bin.install_symlink libexec/"bin/gremlin-server.sh" => "titan-gremlin-server"
  end

  test do
    system "#{bin}/titan", "stop"
  end
end
