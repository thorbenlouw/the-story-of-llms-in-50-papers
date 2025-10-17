#!/bin/bash
#
# Bash script to download seminal LLM papers using curl.
# This script is designed to handle standard arXiv links by appending .pdf
# and a few special non-arXiv links.

# Directory to save the downloaded PDFs
DOWNLOAD_DIR="llm_papers_syllabus"
mkdir -p "$DOWNLOAD_DIR"

# List of papers: "Title"|"arXiv_ID_or_Full_URL"|"Author_Year"
# Note: For simplicity and to create clean filenames, titles are abbreviated and cleaned.
PAPER_LIST=(
    "Attention_Is_All_You_Need|1706.03762|Vaswani_2017"
    "RNN_Regularization|1409.2329|Zaremba_2014"
    "Improving_Language_Understanding_GPT1|https://cdn.openai.com/research-covers/language-unsupervised/language_understanding_paper.pdf|Radford_2018"
    "BERT_Bidirectional_Transformers|1810.04805|Devlin_2018"
    "T5_Unified_Text_to_Text|1910.10683|Raffel_2019"
    "RoFormer_Rotary_Position_Embedding|2104.09864|Su_2021"
    "Scaling_Laws_Neural_Language_Models|2001.08361|Kaplan_2020"
    "Training_Compute_Optimal_LLM|2203.15556|Hoffmann_2022"
    "Switch_Transformers_MoE|2101.03961|Fedus_2021"
    "LLaMA_2_Open_Foundation|2307.09288|Touvron_2023"
    "FlashAttention_Fast_IO_Aware|2205.14135|Dao_2022"
    "GPTQ_Accurate_Post_Training_Quant|2210.17323|Frantar_2022"
    "FLAN_Finetuned_Zero_Shot|2109.01652|Wei_2021"
    "Emergent_Abilities_LLM|2206.07682|Wei_2022"
    "InstructGPT_Training_Instructions|2203.02155|Ouyang_2022"
    "Deep_RL_Human_Preferences|1706.03741|Christiano_2017"
    "DPO_Direct_Preference_Optimization|2305.18290|Rafailov_2023"
    "Constitutional_AI_Harmlessness|2212.08073|Bai_2022"
    "Chain_of_Thought_Reasoning|2201.11903|Wei_2022"
    "ReAct_Reasoning_and_Acting|2210.03629|Yao_2022"
    "RAG_Retrieval_Augmented_Generation|2005.11401|Lewis_2020"
    "Lost_in_the_Middle_Long_Context|2307.03172|Liu_2023"
    "Mamba_Linear_Time_SSM|2312.00752|Gu_Dao_2023"
    "Retentive_Network_RetNet|2307.08621|Wu_2023"
    # --- Extension Track A: Security & Attacks ---
    "Universal_Adversarial_Attacks_Aligned_LLMs|2307.15043|Zou_2023"
    "Breaking_Down_the_Defenses_Attacks_LLMs|https://arxiv.org/pdf/2403.04786|Survey_2024"
    "PoisonedRAG_Knowledge_Corruption_Attacks|2402.07867|Zou_2024"
    "JailbreakZoo_Survey_Jailbreaking_LLMs|2407.01599|Chao_2024"
    # --- Extension Track B: Ethics & Bias ---
    "Dangers_of_Stochastic_Parrots_Bias|https://dl.acm.org/doi/pdf/10.1145/3442188.3445922|Bender_2021"
    "StereoSet_Measuring_Stereotypical_Bias|2004.09456|Nadeem_2020"
    "The_Alignment_Problem_Safety|1606.06565|Amodei_2016"
    "Constitutional_AI_Harmlessness_CAI|2212.08073|Bai_2022"
    # --- Week 7: Evaluation & Benchmarking (Additions) ---
    "HELM_Holistic_Evaluation|2211.09110|Liang_2022"
    "BIG_Bench_Beyond_Imitation_Game|2206.04615|Srivastava_2022"
    # --- Week 9: Factuality & CoT Faithfulness (Additions) ---
    "TruthfulQA_Measuring_Falsehoods|2109.07958|Lin_2021"
    "Measuring_Faithfulness_CoT|2307.13702|Lanham_2023"
    # --- Week 10: Tool Use (Additions) ---
    "Toolformer_LLMs_Use_Tools|2302.04761|Schick_2023"
    "Gorilla_LLM_Connected_APIs|2305.15334|Patil_2023"
    # --- Week 10: Multimodality (Additions) ---
    "Flamingo_Visual_Language_Model|2204.14198|Alayrac_2022"
    "LLaVA_Visual_Instruction_Tuning|2304.08485|Liu_2023"
    "Kosmos_2_Grounding_Multimodal|2306.14824|Peng_2023"
    # --- Week 11: Infra/Serving/PEFT (Additions) ---
    "LoRA_Low_Rank_Adaptation|2106.09685|Hu_2021"
    "vLLM_PagedAttention_Serving|2309.06180|Kwon_2023"
    "MemGPT_LLMs_Operating_Systems|2310.08560|Wu_2023"
    # --- Week 12: Beyond Transformers (Additions) ---
    "Hyena_Hierarchy_Convolutional|2302.10866|Poli_2023"
    "Jamba_Hybrid_Transformer_Mamba|2403.19887|Lieber_2024"
    # --- Extension A: Security Defenses (Additions) ---
    "Red_Teaming_Reduce_Harms|2209.07858|Perez_2022"
    "Watermark_Large_Language_Models|2301.10226|Kirchenbauer_2023"
    "Certified_Robustness_Word_Substitutions|1909.00986|Jia_2019"
    "Poisoning_Instruction_Tuning|2305.00944|Qi_2023"
)

# Function to download a single paper
download_paper() {
    local full_name="$1"
    local source_id="$2"
    local author_year="$3"
    local filename="${DOWNLOAD_DIR}/${full_name}_${author_year}.pdf"
    local url=""

    # 1. Check if the file already exists (unless FORCE=1)
    if [ -f "$filename" ] && [ "${FORCE:-0}" != "1" ]; then
        echo "-> [SKIP] File already exists: $filename (set FORCE=1 to re-download)"
        return 0
    fi

    # 2. Determine the download URL
    # Check if the source is a full URL (e.g., the OpenAI PDF)
    if [[ "$source_id" == "http"* ]]; then
        url="$source_id"
    else
        # Assume standard arXiv ID format and construct the PDF link
        url="https://arxiv.org/pdf/${source_id}"
    fi

    # 3. Download the file
    echo "-> Downloading ${full_name}..."
    echo "   URL: $url"
    # Use curl to download the file. -s silent, -L follow redirects, -o output file, -w for HTTP status
    # -A sets User-Agent to Chrome on Windows
    http_code=$(curl -s -L -A "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36" -w "%{http_code}" "$url" -o "$filename")
    curl_exit_code=$?

    # Check if curl itself failed
    if [ $curl_exit_code -ne 0 ]; then
        echo "   [ERROR] Failed to download from $url (curl exit code: $curl_exit_code)"
        rm -f "$filename"  # Clean up any partial download
        return 1
    fi

    # Check HTTP response code (2xx is success)
    if [ "$http_code" -lt 200 ] || [ "$http_code" -ge 300 ]; then
        echo "   [ERROR] Failed to download from $url (HTTP status: $http_code)"
        rm -f "$filename"  # Clean up any partial download
        return 1
    fi

    # 4. Validate that the downloaded file is actually a PDF
    if ! pdftotext "$filename" - >/dev/null 2>&1; then
        echo "   [ERROR] Downloaded file is not a valid PDF: $filename"
        rm -f "$filename"  # Clean up invalid file
        return 1
    fi

    echo "   [SUCCESS] Saved to: $filename"
    return 0
}

echo "Starting download of ${#PAPER_LIST[@]} LLM research papers to /$DOWNLOAD_DIR..."
echo "--------------------------------------------------------"

# Track failures
failed=0

for item in "${PAPER_LIST[@]}"; do
    # Split the item by the pipe delimiter
    IFS='|' read -r title id year <<< "$item"
    if ! download_paper "$title" "$id" "$year"; then
        failed=1
    fi
done

echo "--------------------------------------------------------"

if [ $failed -eq 1 ]; then
    echo "Download process FAILED. One or more papers could not be downloaded or were not valid PDFs."
    exit 1
else
    echo "Download process complete."
    echo "To view the papers, navigate to the /$DOWNLOAD_DIR directory."
fi
