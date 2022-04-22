class Diamond < Formula
  desc "Accelerated BLAST compatible local sequence aligner"
  homepage "https://www.wsi.uni-tuebingen.de/lehrstuehle/algorithms-in-bioinformatics/software/diamond/"
  url "https://github.com/bbuchfink/diamond/archive/v2.0.15.tar.gz"
  sha256 "cc8e1f3fd357d286cf6585b21321bd25af69aae16ae1a8f605ea603c1886ffa4"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b25c5a7ba1e13f49d35da8b4900cb32cd0c2f7b4fe50c817c13d8b3e34f0ca60"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ab37a61dbad817a0e4dca0310e0473420fde013ffc15f7af5725cde4be961cb0"
    sha256 cellar: :any_skip_relocation, monterey:       "ce33ea102c71dd819f4f9d9e3ba5ebffaa259de08e768c1ceeebec4a42684628"
    sha256 cellar: :any_skip_relocation, big_sur:        "72fb7f8ebf9a4ab1cc82ff79b935d37131c00e8cbbae8d9fe159d781d93b30f7"
    sha256 cellar: :any_skip_relocation, catalina:       "431477a165d719fa67ece1e9bedea04c0377d6a7d4513f631d8bf1ad2e9d859f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2d2e5729a550d2d2394448aaebd968875ecacef041789a0bab314e398701bfe8"
  end

  depends_on "cmake" => :build

  uses_from_macos "zlib"

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    (testpath/"nr.faa").write <<~EOS
      >gnl|alu|HSU14568_Alu_Sb_consensus_rf1
      grarwltpvipalweaeaggsrgqeietilantvkprlyXkyknXpgvvagacspsysgg
      XgrrmaXtreaelavsrdratalqpgrqsetpsqkk
      >gnl|alu|HSU14568_Alu_Sb_consensus_rf2
      agrggsrlXsqhfgrprradhevrrsrpswltrXnpvstkntkisrawwrapvvpatrea
      eagewrepgrrslqXaeiaplhsslgdrarlrlkk
      >gnl|alu|HSU14568_Alu_Sb_consensus_rf3
      pgavahacnpstlggrggritrsgdrdhpgXhgetpsllkiqklagrgggrlXsqllgrl
      rqengvnpgggacseprsrhctpawaterdsvskk
      >gnl|alu|HSU14568_Alu_Sb_consensus_rf-1
      fflrrslalsprlecsgaisahcklrlpgsrhspasasrvagttgarhharlifvflvet
      gfhrvsqdgldlltsXsarlglpkcwdyrrepprpa
      >gnl|alu|HSU14568_Alu_Sb_consensus_rf-2
      ffXdgvslcrpgwsavarsrltassasrvhaillpqppeXlglqapattpgXflyfXXrr
      gftvlarmvsisXprdppasasqsagitgvshrar
      >gnl|alu|HSU14568_Alu_Sb_consensus_rf-3
      ffetesrsvaqagvqwrdlgslqapppgftpfsclslpsswdyrrppprpanfcifsrdg
      vspcXpgwsrspdlvirpprppkvlglqaXatapg
    EOS
    output = shell_output("#{bin}/diamond makedb --in nr.faa -d nr 2>&1")
    assert_match "Database sequences  6\n  Database letters  572", output
  end
end
