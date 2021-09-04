class Benthos < Formula
  desc "Stream processor for mundane tasks written in Go"
  homepage "https://www.benthos.dev"
  url "https://github.com/Jeffail/benthos/archive/v3.54.1.tar.gz"
  sha256 "4b92bfb7cc0fa95f52dca4851e72d42683cfe74907ff26e2876e465bffccd6c8"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "aebd3527b946f4dbc61e953a242c5ebbb8d3c28708dc32f8cf44e33bd10ffc9a"
    sha256 cellar: :any_skip_relocation, big_sur:       "dc9766548af018f342771ccb96ccba198ff2eaab7d91fa54637a071e2da1a561"
    sha256 cellar: :any_skip_relocation, catalina:      "f99992c3b1c9811fca2abf090792a568235515ba0cb49131b7bc7e05463bdc7e"
    sha256 cellar: :any_skip_relocation, mojave:        "c703951df72831251c51158dc6e0a74a6c52c93ed9a2c39bbe348915ba4ed9cf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5c01a6e3ee042cd024604b1d07c1f31568ba35a1a13fe5c4536b14a823f47bb6"
  end

  depends_on "go" => :build

  def install
    system "make", "VERSION=#{version}"
    bin.install "target/bin/benthos"
  end

  test do
    (testpath/"sample.txt").write <<~EOS
      QmVudGhvcyByb2NrcyE=
    EOS

    (testpath/"test_pipeline.yaml").write <<~EOS
      ---
      logger:
        level: ERROR
      input:
        type: file
        file:
          path: ./sample.txt
      pipeline:
        threads: 1
        processors:
         - type: decode
           decode:
             scheme: base64
      output:
        type: stdout
    EOS
    output = shell_output("#{bin}/benthos -c test_pipeline.yaml")
    assert_match "Benthos rocks!", output.strip
  end
end
